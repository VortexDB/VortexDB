# Generate client command
class GenerateCommand < ConsoleCommand
    register(
        "gen",
        "Generate client code for target",
        "gen(targetName, [fileName]) : Void",
        "gen crystal"
    )

    def description : String
        targets = ClientGeneratorFactory.knownGenerators.map { |k, _| k }.join(", ")
        "generate client code for target: #{targets}. Returns \"ok\" if code created"
    end

    # Process command
    def process(client : CommandClient, params : Array(String)) : Void        
        client.sendLine("ok")
    end
end