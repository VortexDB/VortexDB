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
    case contract
    when NewClassErRequest
      processNewClass(client, contract)
    when NewInstanceErRequest
      processNewInstance(client, contract)
    when NewAttributeErRequest
      processNewAttribute(client, contract)      
    when SetAttributeValueErRequest
      processSetAttributeValue(client, contract)
    when GetAttributeValueErRequest
      processGetAttributeValue(client, contract)
    else
    end
  end

  # Process new class request
  private def processNewClass(client : ExternalRequestClient, contract : NewClassErRequest) : Void
    cls = @commandProcessor.createClass(contract.name, contract.parentName)
    sendOkResponse(client)
  end

  # Process new instance
  private def processNewInstance(client : ExternalRequestClient, contract : NewInstanceErRequest) : Void
    inst = @commandProcessor.createInstance(contract.parentName)
    sendOkResponse(client)
  end

  # Process new attribute
  private def processNewAttribute(client : ExternalRequestClient, contract : NewAttributeErRequest) : Void    
    attr = @commandProcessor.createAttribute(contract.parentName, contract.name, contract.valueType, contract.isClass)    
    sendOkResponse(client)
  end

  # Process set attribute value
  private def processSetAttributeValue(client : ExternalRequestClient, contract : SetAttributeValueErRequest) : Void
    @commandProcessor.setAttributeValueByName(
        contract.parentName,
        contract.name,
        contract.value,
        contract.isClass
        )
    sendOkResponse(client)
  end

  # Process get attribute value
  private def processGetAttributeValue(client : ExternalRequestClient, contract : GetAttributeValueErRequest) : Void
    # TODO: specialized exceptions
    value = @commandProcessor.getAttributeValueByName(
      contract.parentName,
        contract.name,        
        contract.isClass
    ).not_nil!
    sendResponse(client, GetAttributeValueErResponse.new(
      value: value.to_s
    ))
  end

  # Process exception
  private def processException(client : ExternalRequestClient, e : Exception) : Void
    begin      
      sendErrorResponse(client, ResponseCodes::INTERNAL_ERROR, e.to_s)
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
