import 'package:args/command_runner.dart';

import 'commands/commands.dart';

Future<int> main(List<String> arguments) async {
  final runner = CommandRunner(
    'gedabak',
    'Tools for managing Dart and/or Flutter projects.',
  )
    ..addCommand(CleanCommand())
    ..addCommand(UpgradeCommand());
  await runner.run(arguments);

  return 0;
}
