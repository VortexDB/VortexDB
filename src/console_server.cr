require "socket"
require "./vortex_exeption"
require "./command_processor"

# Клиент консоли
class CommandClient
  # Сокет клиента
  getter socket : Socket

  # Конструктор
  def initialize(@socket)    
  end

  # Отправляет строку с переводом строки
  def sendLine(message)
    @socket.send("#{message}\n")
  end
end

# Обрабатывает команды консоли
class ConsoleServer
  # Размер буффера
  BUFFER_SIZE = 4096

  # Сервер
  @server : TCPServer

  # Порт на котором работает сервер
  getter port : Int32

  # Для обработки команд
  getter commandProcessor : CommandProcessor

  # Конструктор
  def initialize(@port, @commandProcessor)
    @server = TCPServer.new(@port)
    @server.recv_buffer_size = BUFFER_SIZE
  end

  # Обрабатывает сообщение
  def process(client : CommandClient, message : String) : Void
    cmdList = message.split(" ")
    puts cmdList

    case cmdList[0]
    when "new"
      processNew(client,cmdList)
    when "del"
      processDelete(client, cmdList)
    when "get"
      processGetValue(client, cmdList)
    when "set"
      processSetValue(client, cmdList)
    else
      raise VortexException.new("Unknown command")
    end
  end
  
  # Обрабатывает команду new
  def processNew(client : CommandClient, cmdList : Array(String)) : Void
    case cmdList[1]
    when "class"
      # new class (name)
      processNewClass(client, cmdList)
    when "inst"
      # new inst (base) (name)
      processNewInstance(client, cmdList)
    when "attr"
      # new attr class (class name) (attribute name) (type)
      processNewAttr(client, cmdList)
    else
      raise VortexException.new("Unknown command")
    end
  end

  # Обрабатывает удаление
  def processDelete(client : CommandClient, cmdList : Array(String)) : Void
    case cmdList[1]
    when "class"

    when "inst"

    when "attr"
    else
      raise VortexException.new("Bad request")
    end
  end

  # Обрабатывает получение значения
  def processGetValue(client : CommandClient, cmdList : Array(String)) : Void
    
  end

  # Обрабатывает установление значения
  def processSetValue(client : CommandClient, cmdList : Array(String)) : Void    
  end

  # Process create new class
  def processNewClass(client : CommandClient, cmdList : Array(String)) : Void
    className = cmdList[2]
    parentName = nil    
    parentName = cmdList[3] if cmdList.size > 3
    nclass = @commandProcessor.createClass(className, parentName)
    client.sendLine("Class created Name: #{nclass.name}")
  end

  # Process create new instance
  def processNewInstance(client : CommandClient, cmdList : Array(String)) : Void
    instanceName = cmdList[2]
    #@commandProcessor.createInstance(instanceName)
  end

  # Process create new attribute
  def processNewAttr(client : CommandClient, cmdList : Array(String)) : Void
    attrName = cmdList[3]
    case cmdList[2]
    when "class"
      #processNewClassAttribute(client, cmdList)
    when "instance"
            
    else
      raise VortexException.new("Bad request")      
    end

    #@commandProcessor.createAttribute(instanceName)
  end

  # Process create new class attribute
  def processNewClassAttribute(client : CommandClient, cmdList : Array(String)) : Void
    @commandProcessor.createAttribute()
  end

  # Запускает сервер
  def start : Void
    loop do
      client = @server.accept
      next if client.nil?
      commandClient = CommandClient.new(client)

      spawn do
        loop do
          message = client.gets
          next unless message
          begin
            if message.starts_with?("exit")
              client.close
              break
            end
            process(commandClient, message)
          rescue e : VortexException
            puts e.backtrace
            commandClient.sendLine(e.message!)
          rescue e : Exception
            puts e.backtrace
            commandClient.sendLine("error")
          end
        end
      end
    end
  end
end
