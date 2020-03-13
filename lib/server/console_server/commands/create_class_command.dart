import 'package:vortexdb/common/console/console_client_socket.dart';
import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Create new class command
class CreateClassCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'cc';

  /// Constructor
  CreateClassCommand() : super(Name, 'Create new class');

  /// Process command
  @override
  Future process(ConsoleClientSocket client, List<String> _) async {
    client.send('ok');
  }
}
