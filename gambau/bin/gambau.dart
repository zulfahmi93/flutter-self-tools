import 'package:args/command_runner.dart';

import 'commands/commands.dart';

Future<int> main(List<String> arguments) async {
  final runner = CommandRunner(
    'gambau',
    'Tools for generate app icons for the Flutter projects.',
  )..addCommand(GenerateCommand());
  await runner.run(arguments);

  return 0;
}
