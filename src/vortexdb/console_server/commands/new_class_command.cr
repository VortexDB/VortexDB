# Create new class
class NewClassCommand < ConsoleCommand
    register(
        "nc", 
        "create new class. Returns \"ok\" if class created", 
        "nc(className) : Void",
        "nc Base"
    )

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
        client.sendLine("ok")
    end
end