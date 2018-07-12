# Command to execute
abstract class ConsoleCommand
    macro register(name, description, usage, example)
        getter name = {{ name }}
        getter description = {{ description }}
        getter usage = {{ usage }}
        getter example = {{ example }}

        ConsoleCommandFactory.knownCommands[{{ name }}] = {{ @type }}.new
    end

    # Process command
    abstract def process(client : CommandClient, params : Array(String)) : Void        
end