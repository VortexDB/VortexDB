# Create new class
class NewClassCommand < ConsoleCommand
    register(
        "nc", 
        "Create new class", 
        "nc ClassName",
        "nc Base"
    )

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void

    end
end