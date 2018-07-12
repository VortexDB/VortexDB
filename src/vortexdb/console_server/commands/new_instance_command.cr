# Create new class
class NewInstanceCommand < ConsoleCommand
    register(
        "ni", 
        "create new instance and returns instance id", 
        "ni(className) : Int64",
        "ni Base"
    )

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void

    end
end