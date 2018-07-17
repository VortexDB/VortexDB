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
    className = params[0]
    parentName = nil
    parentName = params[1] if params.size > 1
    nclass = @commandProcessor.createClass(className, parentName)
    pp nclass
    client.sendLine("ok")
  end
end
