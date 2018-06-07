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
    p contract
    processContract(client, contract)
  end

  # Process contract
  private def processContract(client : ExternalRequestClient, contract : ErContract) : Void
    case contract
    when NewClassErContract
      @commandProcessor.createClass(contract.name, contract.parentName)
      contract = CommonErContract.new(
        code: 0,
        text: ""
      )
      dat = contract.toBytes
      client.socket.send(dat)
      p "SENDED"
    else
    end
  end

  # Process exception
  private def processException(client : ExternalRequestClient, e : Exception) : Void
    begin      
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
