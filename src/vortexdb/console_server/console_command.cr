# Command to execute
abstract class ConsoleCommand
    macro register(name, description, usage, example)
        class_getter name = {{ name }}
        class_getter description = {{ description }}
        class_getter usage = {{ usage }}
        class_getter example = {{ example }}

        ConsoleCommandFactory.knownCommands[{{ name }}] = {{ @type }}
    end

    # For processing commands
    getter commandProcessor : CommandProcessor

    def initialize(@commandProcessor)
        
    end

    # Process command
    abstract def process(client : CommandClient, params : Array(String)) : Void        
end