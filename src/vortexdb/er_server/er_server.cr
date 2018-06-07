require "benchmark"
require "kemal"

# Client for server
class ExternalRequestClient
  # Socket of client
  getter socket : HTTP::WebSocket

  def initialize(@socket)
  end
end

# Main server for processing requests
# Uses websockets for transport
class ExternalRequestServer
  # Path for websocket
  WS_PATH = "/kingdom"

  # Server port
  getter port : Int32

  # Command processor
  getter commandProcessor : CommandProcessor

  # Process client
  private def processMessage(client : ExternalRequestClient, data : Bytes) : Void
    contract = MsgPackContract.fromBytes(data).as(ErContract)
    processContract(client, contract)
  end

  # Send response
  private def sendResponse(client : ExternalRequestClient, response)
    dat = response.toBytes
    client.socket.send(dat)
  end

  # Process contract
  private def processContract(client : ExternalRequestClient, contract : ErContract) : Void
    case contract
    when NewClassErRequest
      cls = @commandProcessor.createClass(contract.name, contract.parentName)
      sendResponse(client, NewClassErResponse.new(
        id: cls.id,
        name: cls.name,
        parentName: cls.parentClass.try &.name
      ))
    when NewInstanceErRequest
      inst = @commandProcessor.createInstance(contract.parentName)
      sendResponse(client, NewInstanceErResponse.new(
        id: inst.id,
        parentName: inst.parentClass.name
      ))
    else
    end
  end

  # Process exception
  private def processException(client : ExternalRequestClient, e : Exception) : Void
    begin
      p e
      contract = CommonErContract.new(
        code: 1,
        text: e.message || ""
      )
      client.socket.send(contract.toBytes)
    rescue
      puts "Send error"
    end
  end

  # Process accepted socket
  private def processSocket(socket : HTTP::WebSocket) : Void
    client = ExternalRequestClient.new(socket)
    socket.on_binary do |data|
      begin
        bench = Benchmark.realtime do
          processMessage(client, data)
        end
        puts bench
      rescue e : Exception
        processException(client, e)
      end
    end

    socket.on_close do
      puts "CLOSED"
    end
  end

  def initialize(@port, @commandProcessor)
  end

  # Start server
  def start : Void
    ws WS_PATH do |socket|
      begin
        processSocket(socket)
      rescue
        puts "DISCONNECT"
      end
    end
    Kemal.run port
  end
end
