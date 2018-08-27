# Set instance attribute value
class SetInstanceAttributeValueCommand < ConsoleCommand
  register(
    "siav",
    "Set instance attribute value. Return \"ok\"",
    "siav(className, instanceId, attributeName, value) : Void",
    "siav User 21 name Vader"
  )

  # Process command
  def process(client : CommandClient, params : Array(String)) : Void
    className = params[0]
    instanceId = params[1].to_i64
    attrName = params[2]
    valueStr = params[3]
    @commandProcessor.setInstanceAttributeValue(instanceId, className, attrName, valueStr)
    client.sendLine("ok")
  end
end
