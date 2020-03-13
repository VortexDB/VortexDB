import 'package:vortexdb/common/console/console_client_socket.dart';
import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Create new instance of class command
class CreateInstanceCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'ci';

  /// Constructor
  CreateInstanceCommand() : super(Name, 'Create new instance of class');

  /// Process command
  @override
  Future process(ConsoleClientSocket client, List<String> _) async {
    client.send('ok');
  }
}
