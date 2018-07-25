# List instances
class ListInstancesCommand < ConsoleCommand
    register(
      "li",
      "List instances of class. Returns array of instanceId or \"empty\"",
      "li(className) : Array(instanceId)",
      "li User"
    )
  
    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
      className = params[0]
      count = 0
      @commandProcessor.iterateClassInstances(className) do |instance|
        client.sendLine("#{instance.id}")
        count = count + 1
      end
      if count < 1
        client.sendLine("empty")
      end
    end
  end
  