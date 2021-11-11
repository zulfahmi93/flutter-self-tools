import 'dart:io';

import 'package:args/command_runner.dart';

import '../pubspec/pubspec.dart';

class CleanCommand extends Command {
  // ---------------------------- CONSTRUCTORS ----------------------------
  CleanCommand() {
    argParser.addOption('path', abbr: 'p');
    argParser.addFlag('verbose', abbr: 'v');
  }

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get description => 'Run `flutter clean` for all packages.';

  @override
  String get name => 'clean';

  // ------------------------------- METHODS ------------------------------
  @override
  Future<void> run() async {
    final path = argResults?['path'];
    final verbose = argResults?['verbose'];

    final directory = path != null ? Directory(path) : Directory.current;

    final projects = await getAllProjects(
      directory: directory,
      includeExampleProjects: true,
    );

    for (final project in projects.values) {
      print('Cleaning ${project.name}');
      final projectDirectory = File(project.pubspecPath).parent;
      await Process.run(
        Platform.isWindows ? 'fvm.bat' : 'fvm',
        [
          'flutter',
          'clean',
          if (verbose == true) '-v',
        ],
        workingDirectory: projectDirectory.path,
      );
    }

    print('Cleaning all symlinks');
    final items = directory.list(recursive: true, followLinks: false);
    await for (final item in items) {
      if (item is Link) {
        await item.delete();
      }
    }
  }
}
