import 'package:vortexdb/server/console_server/commands/console_command.dart';
import 'package:vortexdb/server/console_server/commands/create_class_attribute_command.dart';
import 'package:vortexdb/server/console_server/commands/create_class_command.dart';
import 'package:vortexdb/server/console_server/commands/create_instance_attribute_command.dart';
import 'package:vortexdb/server/console_server/commands/create_instance_command.dart';
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
    _commands[CreateClassCommand.Name] = CreateClassCommand();
    _commands[CreateInstanceCommand.Name] = CreateInstanceCommand();
    _commands[CreateClassAttributeCommand.Name] = CreateClassAttributeCommand();
    _commands[CreateInstanceAttributeCommand.Name] =
        CreateInstanceAttributeCommand();
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
