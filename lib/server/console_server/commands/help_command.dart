import 'dart:io';

import 'package:vortexdb/server/console_server/command_factory.dart';
import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Print help for user
class HelpCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'help';

  /// Constructor
  HelpCommand() : super(Name, 'Print help');

  @override
  Future process(Socket client, List<String> _) async {
    final commands = CommandFactory.instance.getCommands();
    for (var command in commands) {
      client.writeln('${command.name} - ${command.description}');
    }
  }
}