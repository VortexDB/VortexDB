# Create new instance attribute
class NewInstanceAttributeCommand < ConsoleCommand
  register(
    "nia",
    "create new instance attribute. Returns attribute id",
    "nia(className, attributeName, valueType) : Int64",
    "nia Base name string"
  )

  # Process command
  def process(client : CommandClient, params : Array(String)) : Void
    className = params[0]
    name = params[1]
    valueTypeStr = params[2]
    nattr = @commandProcessor.createAttribute(className, name, valueTypeStr, false)
    pp nattr
    client.sendLine(nattr.id)
  end
end
