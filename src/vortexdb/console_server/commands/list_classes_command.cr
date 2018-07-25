# List all classes
class ListClassesCommand < ConsoleCommand
    register(
      "lc",
      "List classes. Returns array of class names or \"empty\"",
      "lc : Array(className)",
      "lc"
    )
  
    # Process command
    def process(client : CommandClient, params : Array(String)) : Void
      count = 0
      @commandProcessor.iterateClasses do |cls|
        client.sendLine("#{cls.name}")
        count = count + 1
      end
      if count < 1
        client.sendLine("empty")
      end
    end
  end
  