import 'dart:io';

import 'package:vortexdb/common/console/console_client_socket.dart';
import 'package:vortexdb/server/console_server/command_factory.dart';
import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Print help for user
class HelpCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'help';

  /// Constructor
  HelpCommand() : super(Name, 'Print help');

  @override
  Future process(ConsoleClientSocket client, List<String> _) async {
    final commands = CommandFactory.instance.getCommands();
    final data = commands.map((x) => '${x.name} - ${x.description}').join('\n');
    client.send(data);
  }
}
