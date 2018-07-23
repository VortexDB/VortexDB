# Get class attribute value
class GetClassAttributeValueCommand < ConsoleCommand
    register(
      "gcav",
      "Get class attribute value. Return value",
      "gcav(className, attributeName) : String",
      "gcav User name"
    )
  
    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
      className = params[0]
      attrName = params[1]
      value = @commandProcessor.getClassAttributeValue(className, attrName)
      client.sendLine(value)
    end
  end
  