# Set class attribute value
class SetClassAttributeValueCommand < ConsoleCommand
    register(
      "scav",
      "Set class attribute value. Returns \"ok\"",
      "scav(className, attributeName, value) : Int64",
      "scav Base name some_string \n\
       scav Human age 32 \n\
      "
    )
  
    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
      parentName = params[0]
      ninst = @commandProcessor.createInstance(parentName)
      pp ninst
      client.sendLine("#{ninst.id}")
    end
  end
  