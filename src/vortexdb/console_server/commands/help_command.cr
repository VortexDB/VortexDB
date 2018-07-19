# Help
class HelpCommand < ConsoleCommand
  register(
    "help",
    "get command list and command info",
    "help([commandName])",
    "help \n\
    help nc \n\
    help ni \n\
    "
  )

  # Process command
  def process(client : CommandClient, params : Array(String)) : Void
    cmdName = params[0]?
    if cmdName
      command = ConsoleCommandFactory.get(cmdName, @commandProcessor)
      if command
        client.sendLine("Description: #{command.class.description}")
        client.sendLine("Usage: #{command.class.usage}")
        client.sendLine("Example: \n#{command.class.example}")
      else
        client.sendLine("Unknown command")
      end
    else
      ConsoleCommandFactory.knownCommands.values.each do |command|
        client.sendLine("#{command.name} - #{command.description}")
      end
      client.sendLine("exit - exit from console")

      client.sendLine("")
      client.sendLine("To get command info type help command name")
    end
  end
end
