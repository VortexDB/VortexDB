# Help
class HelpCommand < ConsoleCommand
    register(
        "help",
        "get help and command list",
        "",
        ""
    )

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
        ConsoleCommandFactory.knownCommands.values.each do |command|
            client.sendLine("#{command.name} - #{command.description}")
        end
        client.sendLine("exit - exit from console")
    end
end