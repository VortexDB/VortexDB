# List class attributes
class ListClassAttributeCommand < ConsoleCommand
    register(
      "lca",
      "List class attributes. Returns attribute info",
      "lca(className) : {attributeId, attributeName, valueType}",
      "lca User"
    )
  
    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
      className = params[0]      
      @commandProcessor.iterateClassAttributes(className) do |attribute|
        client.sendLine("#{attribute.id} #{attribute.name} #{attribute.valueType}")
      end      
    end
  end
  