import 'package:vortexdb/common/console/console_client_socket.dart';
import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Create new attribute of instance command
class CreateInstanceAttributeCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'cia';

  /// Constructor
  CreateInstanceAttributeCommand() : super(Name, 'Create new attribute for instance');

  /// Process command
  @override
  Future process(ConsoleClientSocket client, List<String> _) async {
    client.send('ok');
  }
}
