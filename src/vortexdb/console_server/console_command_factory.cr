# Factory fo creating commands
class ConsoleCommandFactory
    # Known console commands
    class_property knownCommands = Hash(String, ConsoleCommand.class).new

    # Get command by name
    def self.get(name : String, commandProcessor : CommandProcessor) : ConsoleCommand?
        command = knownCommands[name]?
        if command
            return command.new(commandProcessor)
        end        
    end
end