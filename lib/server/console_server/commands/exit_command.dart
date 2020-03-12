import 'dart:io';

import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Exit from console server
class ExitCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'exit';

  /// Constructor
  ExitCommand() : super(Name, 'Disconnect from console server');

  @override
  Future process(Socket client, List<String> _) async {
    await client.close();
  }
}
