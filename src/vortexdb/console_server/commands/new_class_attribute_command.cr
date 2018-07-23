# Create new class
class NewClassAttributeCommand < ConsoleCommand
  register(
    "nca",
    "create new class attribute. Returns attribute id",
    "nca(className, attributeName, valueType) : Int64",
    "nca Base id int"
  )

  # Process command
  def process(client : CommandClient, params : Array(String)) : Void
    className = params[0]
    name = params[1]
    valueTypeStr = params[2]
    nattr = @commandProcessor.createAttribute(className, name, valueTypeStr, true)
    pp nattr
    client.sendLine(nattr.id)
  end
end
