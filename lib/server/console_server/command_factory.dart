import 'package:vortexdb/server/console_server/commands/console_command.dart';
import 'package:vortexdb/server/console_server/commands/exit_command.dart';
import 'package:vortexdb/server/console_server/commands/help_command.dart';

/// Factory of console commands
class CommandFactory {
  /// Single instance
  static final instance = CommandFactory._();

  final _commands = <String, ConsoleCommand>{};

  /// Private constructor
  CommandFactory._() {
    _commands[HelpCommand.Name] = HelpCommand();
    _commands[ExitCommand.Name] = ExitCommand();    
  }

  /// Return all commands as list
  List<ConsoleCommand> getCommands() {
    return _commands.values.toList();
  }

  /// Return command or null if it does not exists
  ConsoleCommand getCommand(String name) {
    return _commands[name];
  }
}
