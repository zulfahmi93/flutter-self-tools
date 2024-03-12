import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../pubspec/pubspec.dart';
import '../utils/utils.dart';

typedef _Package = (String name, Version version);
typedef _Dependencies = (
  _DependencyMap dependencies,
  _DependencyMap devDependencies,
);
typedef _DependencyMap = Map<String, Version>;

class UpgradeCommand extends Command with LogMixin {
  // ---------------------------- CONSTRUCTORS ----------------------------
  UpgradeCommand() {
    argParser.addOption('path', abbr: 'p');
    argParser.addFlag('verbose', abbr: 'v');
  }

  // ------------------------------- FIELDS -------------------------------
  final _cache = _DependencyMap();
  late final bool _verbose;

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get description => 'Upgrade the packages dependencies.';

  @override
  String get name => 'upgrade';

  @override
  bool get verbose => _verbose;

  // ------------------------------- METHODS ------------------------------
  @override
  Future<void> run() async {
    if (argResults == null) {
      print(usage);
      return;
    }

    final projectPath = argResults?['path'];
    _verbose = argResults!['verbose'] as bool;

    final directory =
        projectPath != null ? Directory(projectPath) : Directory.current;

    final projects = await getAllProjects(
      directory: directory,
      includeExampleProjects: true,
    );

    final lockedDependencies = await _loadFlutterPubspec();

    for (final project in projects.values) {
      logInfo('Upgrading all dependencies for package ${project.name}.');

      final (dependencies, devDependencies) =
          await _parsePubspec(project.pubspecPath);

      for (var i = 1; i < project.pubspecContent.length; i++) {
        var line = project.pubspecContent[i];
        if (line.startsWith('dependencies:') ||
            line.startsWith('dev_dependencies:')) {
          i++;
          while (i < project.pubspecContent.length) {
            line = project.pubspecContent[i];
            if (line.isEmpty) {
              break;
            }

            final package = _parseLine(
              line: line,
              dependencies: dependencies,
              devDependencies: devDependencies,
            );
            if (package == null) {
              i++;
              continue;
            }

            final newLine = await _upgradePackage(
              package: package,
              lockedDependencies: lockedDependencies,
            );
            if (newLine != null) {
              project.pubspecContent[i] = '  $newLine';
            }

            i++;
          }

          continue;
        }
      }

      if (!await updatePubspec(project)) {
        logWarning('Failed to update ${project.name}!');
      }
    }
  }

  _Package? _parseLine({
    required String line,
    required _DependencyMap dependencies,
    required _DependencyMap devDependencies,
  }) {
    final split = line.split(':');
    if (split.length != 2) {
      return null;
    }

    final packageName = split[0].trim();
    final currentVersion =
        dependencies[packageName] ?? devDependencies[packageName];
    if (currentVersion == null ||
        currentVersion.isAny ||
        currentVersion.isEmpty) {
      return null;
    }

    logVerbose('Attempting to upgrade $packageName.');
    return (packageName, currentVersion);
  }

  Future<String?> _upgradePackage({
    required _Package package,
    required _DependencyMap lockedDependencies,
  }) async {
    final (packageName, packageVersion) = package;
    final cachedVersion = _cache[packageName];

    if (lockedDependencies.containsKey(packageName)) {
      return _upgradeLockedPackage(
        package: package,
        lockedDependencies: lockedDependencies,
      );
    }

    if (cachedVersion != null) {
      logVerbose('Upgrading $packageName to ^$cachedVersion.');
      return '$packageName: ^$cachedVersion';
    }

    final client = PubClient();
    final info = await client.packageInfo(packageName);

    final latestVersion = Version.parse(info.version);
    if (latestVersion <= packageVersion) {
      return null;
    }

    logVerbose('Upgrading $packageName to ^$latestVersion');

    _cache[packageName] = latestVersion;
    return '$packageName: ^$latestVersion';
  }

  Future<String?> _upgradeLockedPackage({
    required _Package package,
    required _DependencyMap lockedDependencies,
  }) async {
    final (packageName, packageVersion) = package;

    final lockedVersion = lockedDependencies[packageName]!;
    logVerbose('$packageName locked by Flutter SDK to version $lockedVersion.');

    if (lockedVersion <= packageVersion) {
      return null;
    }

    logVerbose('Upgrading $packageName to $lockedVersion.');
    return '$packageName: ^$lockedVersion';
  }

  Future<_DependencyMap> _loadFlutterPubspec() async {
    final result = await Process.run('which', ['flutter']);
    final flutterExe = File(result.stdout as String);
    final flutterDirectory = flutterExe.parent.parent;
    final packagesDirectory = path.join(flutterDirectory.path, 'packages');

    final (d1, _) = await _parsePubspec(
      path.join(packagesDirectory, 'flutter'),
    );
    final (d2, _) = await _parsePubspec(
      path.join(packagesDirectory, 'flutter_localizations'),
    );

    // Detect inconsistencies
    d1.forEach((key, value) {
      if (d2.containsKey(key) && d2[key] != d1[key]) {
        logFatal('Detected inconsistencies in Flutter SDK pubspec!');
        exit(1);
      }
    });

    d1.addAll(d2);
    return d1;
  }

  Future<_Dependencies> _parsePubspec(String pubspecPath) async {
    if (!pubspecPath.contains('pubspec.yaml')) {
      pubspecPath = path.join(pubspecPath, 'pubspec.yaml');
    }
    final file = File(pubspecPath);
    final yaml = await file.readAsString();
    final doc = loadYamlDocument(yaml);

    final root = doc.contents as YamlMap;
    final deps = root['dependencies'] as YamlMap;
    final devDeps = root['dev_dependencies'] as YamlMap;

    _DependencyMap populate(YamlMap yamlMap) {
      final dependencyMap = _DependencyMap();

      for (final key in yamlMap.keys.whereType<String>()) {
        if (yamlMap[key] is String) {
          var raw = (yamlMap[key] as String).trim();
          if (raw.startsWith('^')) {
            raw = raw.substring(1);
          }

          try {
            dependencyMap[key] = Version.parse(raw);
          } on FormatException {
            logFatal('Unable to parse pubspec.yaml!');
            exit(2);
          }
        }
      }

      return dependencyMap;
    }

    final dependencies = populate(deps);
    final devDependencies = populate(devDeps);

    return (dependencies, devDependencies);
  }
}
