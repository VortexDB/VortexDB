# List instance attributes
class ListInstanceAttributeCommand < ConsoleCommand
    register(
      "lia",
      "List instance attributes. Returns attribute info",
      "lia(className) : {attributeId, attributeName, valueType}",
      "lia User"
    )
  
    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
      className = params[0]
      @commandProcessor.iterateInstanceAttributes(className) do |attribute|
        client.sendLine("#{attribute.id} #{attribute.name} #{attribute.valueType}")
      end
    end
  end
  