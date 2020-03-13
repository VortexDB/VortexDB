import 'package:vortexdb/common/console/console_client_socket.dart';

/// Base console command class
abstract class ConsoleCommand {
  /// Command name
  final String name;

  /// Command description
  final String description;

  /// Constructor
  ConsoleCommand(this.name, this.description);

  /// Process command
  Future process(ConsoleClientSocket client, List<String> parameters);
}