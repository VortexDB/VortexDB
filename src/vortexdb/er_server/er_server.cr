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
    erContract = MsgPackContract.fromBytes(data).as(ErContract)
    p erContract
    processContract(client, erContract)
  end

  # Process contract
  private def processContract(client : ExternalRequestClient, contract : ErContract) : Void
    case contract
    when NewClassErContract
      @commandProcessor.createClass(contract.name, contract.parentName)
    else
      
    end
  end

  def initialize(@port, @commandProcessor)
  end

  # Start server
  def start : Void
    ws WS_PATH do |socket|
      spawn do
        begin
          client = ExternalRequestClient.new(socket)
          socket.on_binary do |data|
            puts data.hexstring
            processMessage(client, data)
          end          
        rescue e : Exception
          # TODO: handle error
          puts e
        end
      end
    end
    Kemal.run port
  end
end
