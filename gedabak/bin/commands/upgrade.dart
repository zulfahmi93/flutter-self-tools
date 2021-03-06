import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';

import '../pubspec/pubspec.dart';

class UpgradeCommand extends Command {
  // ---------------------------- CONSTRUCTORS ----------------------------
  UpgradeCommand() {
    argParser.addOption('path', abbr: 'p');
    argParser.addFlag('verbose', abbr: 'v');
  }

  // ------------------------------- FIELDS -------------------------------
  final _cache = <String, String>{};

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get description => 'Upgrade the packages dependencies.';

  @override
  String get name => 'upgrade';

  // ------------------------------- METHODS ------------------------------
  @override
  Future<void> run() async {
    if (argResults == null) {
      print(usage);
      return;
    }

    final path = argResults?['path'];
    final verbose = argResults!['verbose'] as bool;

    final directory = path != null ? Directory(path) : Directory.current;

    final projects = await getAllProjects(
      directory: directory,
      includeExampleProjects: true,
    );

    for (final project in projects.values) {
      print('Upgrading all dependencies for package ${project.name}');

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

            final newLine = await _upgradePackage(line, verbose);
            if (newLine != null) {
              project.pubspecContent[i] = newLine;
            }

            i++;
          }

          continue;
        }
      }

      if (!await updatePubspec(project)) {
        stderr.writeln('WARNING: Failed to update ${project.name}!');
      }
    }
  }

  Future<String?> _upgradePackage(String raw, bool verbose) async {
    final split = raw.split(':');
    if (split.length != 2) {
      return null;
    }

    final packageName = split[0].trim();
    var versionTemp = split[1].trim();
    while (versionTemp.isNotEmpty && !RegExp('\\d').hasMatch(versionTemp[0])) {
      versionTemp = versionTemp.substring(1);
    }
    final version = versionTemp.trim();

    if (verbose) {
      print('[VERBOSE] Attempting to upgrading $packageName');
    }

    Version? currentVersion;
    try {
      currentVersion = Version.parse(version);
    } on FormatException {
      print('[WARNING] Unable to upgrade $packageName');
      return null;
    }

    if (_cache.containsKey(packageName)) {
      if (verbose) {
        print('[VERBOSE] Upgrading $packageName to ${_cache[packageName]}');
      }
      return '${split[0]}: ${_cache[packageName]}';
    }

    final client = PubClient();
    final info = await client.packageInfo(packageName);

    final latestVersion = Version.parse(info.version);
    if (latestVersion <= currentVersion) {
      return null;
    }

    if (verbose) {
      print('[VERBOSE] Upgrading $packageName to ${latestVersion.toString()}');
    }

    _cache[packageName] = '^${latestVersion.toString()}';
    return '${split[0]}: ${_cache[packageName]}';
  }
}
