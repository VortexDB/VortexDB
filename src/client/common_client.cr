require "../vortexdb/**"

alias Completers = Completer(CVClass) |
                   Completer(CVInstance)

# Common client with base functions
class CommonClient
  # Socket to connect
  @socket : HTTP::WebSocket?

  # Server host
  @host : String

  # Server port
  @port : Int32

  # Completers
  @completers = Array(Completers).new

  private def socket!
    @socket.not_nil!
  end

  # Send contract
  private def sendContract(contract : ErContract) : Void
    socket!.send(contract.toBytes)
  end

  def initialize(@host : String, @port : Int32)
  end

  # Open client
  def open : Void
    socket = HTTP::WebSocket.new(@host, ExternalRequestServer::WS_PATH, @port)
    @socket = socket

    socket.on_binary do |data|
      contract = MsgPackContract.fromBytes(data).as(ErContract)
      case contract
      when NewClassErResponse
        completer = @completers.pop.as(Completer(CVClass))
        completer.complete(
          CVClass.new(
            id: contract.id,
            name: contract.name,
            parentName: contract.parentName
          )
        )
      when NewInstanceErResponse
        completer = @completers.pop.as(Completer(CVInstance))
        completer.complete(
          CVInstance.new(
            id: contract.id,
            parentName: contract.parentName
          )
        )
      else
      end
    end

    socket.on_close do
      puts "CLOSED"
    end

    spawn do
      socket.run
    end
  end

  # Create class
  def createClass(name : String, parentName : String? = nil) : Future(CVClass)
    completer = Completer(CVClass).new

    sendContract(
      NewClassErRequest.new(
        name: name,
        parentName: parentName
      ))

    @completers.push(completer)
    return completer.future
  end

  # Create instance
  def createInstance(parentName : String) : Future(CVInstance)
    completer = Completer(CVInstance).new
    sendContract(
      NewInstanceErRequest.new(
        parentName: parentName
      ))

    @completers.push(completer)
    return completer.future
  end
end
