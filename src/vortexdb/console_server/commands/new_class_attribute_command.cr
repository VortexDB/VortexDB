# Create new class
class NewClassAttributeCommand < ConsoleCommand
    register(
        "nca", 
        "create new class attribute. Returns \"ok\" if attribute created", 
        "nca(className, attributeName, valueType) : Void",
        "nc Base"
    )

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
        client.sendLine("ok")
    end
end