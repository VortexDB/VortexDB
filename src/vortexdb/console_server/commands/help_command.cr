# Help
class HelpCommand < ConsoleCommand
    register(
        "help",
        "get command list and command info",
        "help([CommandName])",
        "help \ 
         help nc\
         help ni\
        "
    )

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
        ConsoleCommandFactory.knownCommands.values.each do |command|
            client.sendLine("#{command.name} - #{command.description}")
        end
        client.sendLine("exit - exit from console")
        
        client.sendLine("")
        client.sendLine("To get command info type help command name")        
    end
end