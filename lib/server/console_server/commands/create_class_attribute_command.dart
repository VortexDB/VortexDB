import 'package:vortexdb/common/console/console_client_socket.dart';
import 'package:vortexdb/server/console_server/commands/console_command.dart';

/// Create new attribute of class command
class CreateClassAttributeCommand extends ConsoleCommand {
  /// Command name
  static const Name = 'cca';

  /// Constructor
  CreateClassAttributeCommand() : super(Name, 'Create new attribute for class');

  /// Process command
  @override
  Future process(ConsoleClientSocket client, List<String> _) async {
    client.send('ok');
  }
}
