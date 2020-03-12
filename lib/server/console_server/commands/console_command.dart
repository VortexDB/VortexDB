import 'dart:io';

/// Base console command class
abstract class ConsoleCommand {
  /// Command name
  final String name;

  /// Command description
  final String description;

  /// Constructor
  ConsoleCommand(this.name, this.description);

  /// Process command
  Future process(Socket client, List<String> parameters);
}