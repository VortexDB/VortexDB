# Factory fo creating commands
class ConsoleCommandFactory
    # Known console commands
    class_property knownCommands = Hash(String, ConsoleCommand.class).new

    # Get command by name
    def self.get(name : String) : ConsoleCommand
        knownCommands[name].new
    end
end