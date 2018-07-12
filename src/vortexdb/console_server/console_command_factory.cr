# Factory fo creating commands
class ConsoleCommandFactory
    # Known console commands
    class_property knownCommands = Hash(String, ConsoleCommand).new

    # Get command by name
    def self.get(name : String) : ConsoleCommand?
        command = knownCommands[name]?
        if command
            return command
        end        
    end
end