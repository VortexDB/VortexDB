require "benchmark"
require "socket"

# Обрабатывает команды консоли
class ConsoleServer
  # Размер буффера
  BUFFER_SIZE = 4096

  # TCP Server
  @server : TCPServer

  # Console commands hash
  @commands : Hash(String, ConsoleCommand)

  # Server port
  getter port : Int32

  # Command processor
  getter commandProcessor : CommandProcessor

  def initialize(@port, @commandProcessor)
    @server = TCPServer.new(@port)
    @server.recv_buffer_size = BUFFER_SIZE
    @commands = Hash(String, ConsoleCommand).new
  end

  # Process message
  def process(client : CommandClient, message : String) : Void
    cmdList = message.split(" ")

    commandName = cmdList[0]
    command = ConsoleCommandFactory.get(commandName, @commandProcessor)    
    if command
      command.process(client, cmdList[1..-1])
    else
      client.sendLine("Unknown command. Use \"help\" to list commands")
    end

    # case commandName
    # when "nc" # new class
    #   processNewClass(client, cmdList)
    # when "ni" # new instance
    #   processNewInstance(client, cmdList)
    # when "nca" # new class attribute
    #   processNewClassAttribute(client, cmdList)
    # when "nia" # new instance attribute
    #   processNewInstanceAttribute(client, cmdList)
    # when "scav" # set class attribute value
    #   processSetClassAttributeValue(client, cmdList)
    # when "gcav" # get class attribute value
    #   processGetClassAttributeValue(client, cmdList)
    # when "siav" # set instance attribute value
    #   processSetInstanceAttributeValue(client, cmdList)
    # when "giav" # get instance attribute value
    #   processGetInstanceAttributeValue(client, cmdList)
    # when "dc" # delete class
    #   # processDelete(client, cmdList)
    # when "dca" # delete class attribute
    #   # processGetValue(client, cmdList)
    # when "di" # delete instance
    #   # processSetValue(client, cmdList)
    # when "lc" # List classes
    #   processListClass(client, cmdList)
    # when "li" # List instances
    #   processListInstance(client, cmdList)
    # when "lci" # List class instances
    #   processListClassInstance(client, cmdList)
    # when "gen" # Generate client
    #   processGenerate(client, cmdList)
    # else
    #   raise VortexException.new("Unknown command")
    # end
  end   

  # Set class attribute value
  # (class) (name) (value)
  def processSetClassAttributeValue(client : CommandClient, cmdList : Array(String)) : Void
    attrWithValue = @commandProcessor.setClassAttributeValueByName(cmdList[1], cmdList[2], cmdList[3])
    # p attrWithValue
    client.sendLine("ok")
  end

  # Process get class attribute value
  # (class) (name)
  def processGetClassAttributeValue(client : CommandClient, cmdList : Array(String)) : Void
    attrWithValue = @commandProcessor.getClassAttributeValueByName(cmdList[1], cmdList[2])

    if attrWithValue.nil?
      client.sendLine("null")
    else
      client.sendLine(attrWithValue.value)
    end
  end

  # Set instance attribute value
  # (instanceId) (name) (value)
  def processSetInstanceAttributeValue(client : CommandClient, cmdList : Array(String)) : Void
    # attrWithValue = @commandProcessor.setAttributeValueByName(cmdList[1], cmdList[2], cmdList[3], false)
    # p attrWithValue
    client.sendLine("ok")
  end

  # Process get instance attribute value
  # (instanceId) (name)
  def processGetInstanceAttributeValue(client : CommandClient, cmdList : Array(String)) : Void
    # attrWithValue = @commandProcessor.getAttributeValueByName(cmdList[1], cmdList[2], true)

    # if attrWithValue.nil?
    #   client.sendLine("null")
    # else
    #   client.sendLine(attrWithValue.value)
    # end
  end

  # List all classes
  def processListClass(client : CommandClient, cmdList : Array(String)) : Void
    count = 0
    @commandProcessor.iterateClasses do |x|
      parentName = (x.parentClass.try &.name)
      client.sendLine("#{x.id} #{x.name} #{parentName}")
      count += 1
    end
    client.sendLine("Class count: #{count}")
  end

  # List all instances
  def processListInstance(client : CommandClient, cmdList : Array(String)) : Void
    count = 0
    @commandProcessor.iterateInstances do |x|
      parentName = (x.parentClass.try &.name)
      client.sendLine("#{parentName} #{x.id}")
      count += 1
    end
    client.sendLine("Instance count: #{count}")
  end

  # List class instances
  def processListClassInstance(client : CommandClient, cmdList : Array(String)) : Void
    className = cmdList[1]

    count = 0
    @commandProcessor.iterateClassInstances(className) do |x|
      client.sendLine("#{className} #{x.id}")
      count += 1
    end

    client.sendLine("Instance count: #{count}")
  end

  # List all classes
  def processListClassInstances(client : CommandClient, cmdList : Array(String)) : Void
  end

  # Generate client contracts
  def processGenerate(client : CommandClient, cmdList : Array(String)) : Void
    targetName = cmdList[1]
    @commandProcessor.generateClient(targetName)
    client.sendLine("Ok")
  end

  # Send welcome to client
  def sendWelcome(client : CommandClient) : Void
    client.sendLine("Welcome to VortexDB console.")
    client.sendLine("Type \"help\" to get commands list.")
  end

  # Start server
  def start : Void
    loop do
      client = @server.accept
      next if client.nil?
      commandClient = CommandClient.new(client)
      sendWelcome(commandClient)

      spawn do
        loop do
          begin
            message = client.gets            
            unless message
              client.close
              break
            end

            puts message
            if message.starts_with?("exit")
              client.close
              break
            end
            bench = Benchmark.realtime do
              process(commandClient, message)
            end
            puts bench
          rescue e : VortexException
            puts e.inspect_with_backtrace
            commandClient.sendLine(e.message!)
          rescue e : Exception
            puts e.inspect_with_backtrace
            commandClient.sendLine("error")
          end
        end
      end
    end
  end
end
