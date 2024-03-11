import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../models/models.dart';

Future<Projects> getAllProjects({
  required Directory directory,
  required bool includeExampleProjects,
}) async {
  final projects = <String, Project>{};

  final items = directory.list(recursive: true, followLinks: false);
  await for (final file in items) {
    final path = file.uri.toFilePath(windows: false);
    if (!path.contains('pubspec.yaml')) {
      continue;
    }
    if (path.contains('example/pubspec.yaml') && !includeExampleProjects) {
      continue;
    }

    final pubspecFile = File(file.path);
    if (!await pubspecFile.exists()) {
      continue;
    }

    final pubspecYaml = await pubspecFile.readAsString();
    final pubspecDoc = loadYamlDocument(pubspecYaml);
    final pubspecMap = pubspecDoc.contents as YamlMap;

    final lines = LineSplitter.split(pubspecYaml).toList();

    final packageName = pubspecMap['name'];
    if (packageName == 'synthetic_package') {
      continue;
    }

    projects[packageName] = Project(
      name: packageName,
      pubspecPath: file.path,
      pubspecContent: lines,
      dependencies: {},
    );
  }

  for (final project in projects.values) {
    final lines = project.pubspecContent;
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains(RegExp('name:'))) {
        final packageDepName = line.substring(line.indexOf('name:') + 5).trim();
        final dependency = projects[packageDepName];
        if (dependency != null) {
          project.dependencies[packageDepName] = dependency;
        }
      }
    }
  }

  return projects;
}
