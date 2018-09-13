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
  # Command processor
  getter commandProcessor : CommandProcessor

  # Send response
  private def sendResponse(client : ExternalRequestClient, response) : Void
    dat = response.toBytes
    client.socket.send(dat)
  end

  # Send ok response
  private def sendOkResponse(client : ExternalRequestClient) : Void
    sendResponse(client, CommonErResponse.new(
      code: ResponseCodes::OK,
      text: nil
    ))
  end

  # Send error response
  private def sendErrorResponse(client : ExternalRequestClient, code : Int32, text : String? = nil) : Void
    sendResponse(client, CommonErResponse.new(
      code: code,
      text: text
    ))
  end

  # Process client
  private def processMessage(client : ExternalRequestClient, data : Bytes) : Void
    contract = MsgPackContract.fromBytes(data).as(ErContract)
    processContract(client, contract)
  end

  # Process contract
  private def processContract(client : ExternalRequestClient, contract : ErContract) : Void
    p contract
    processor = ContractProcessorFactory.get(contract.class, @commandProcessor)    
    if processor
      processor.process(client, contract)
    end
  end  

  # Process exception
  private def processException(client : ExternalRequestClient, e : Exception) : Void
    begin
      case e
      when VortexException
        # TODO: Response exception
        sendErrorResponse(client, ResponseCodes::INTERNAL_ERROR, e.message!)
      else
        sendErrorResponse(client, ResponseCodes::INTERNAL_ERROR, e.to_s)
      end
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

  def initialize(@commandProcessor)
  end

  # Start server
  def start : Void
    ws VortexCommon::VORTEX_EXTERNAL_PATH do |socket|
      begin
        processSocket(socket)
      rescue
        puts "DISCONNECT"
      end
    end    
  end
end
