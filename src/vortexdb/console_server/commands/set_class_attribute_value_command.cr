# Set class attribute value
class SetClassAttributeValueCommand < ConsoleCommand
  register(
    "scav",
    "Set class attribute value. Return \"ok\"",
    "scav(className, attributeName, value) : Void",
    "scav User name Joe"
  )

  # Process command
  def process(client : CommandClient, params : Array(String)) : Void
    className = params[0]
    attrName = params[1]
    valueStr = params[2]
    @commandProcessor.setClassAttributeValue(className, attrName, valueStr)
    client.sendLine("ok")
  end
end
