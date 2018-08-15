# Abstract contract processor
abstract class ContractProcessor
  macro register(contractClass)
    ContractProcessorFactory.knownProcessors[{{ contractClass }}] = {{ @type }}

    def process(client : ExternalRequestClient, contract : ErContract) : Void
      processInternal(client, contract.as({{ contractClass }}))
    end
  end

  # For processing contract
  @commandProcessor : CommandProcessor

  # Send response
  protected def sendResponse(client : ExternalRequestClient, response) : Void
    dat = response.toBytes
    client.socket.send(dat)
  end

  # Send ok response
  protected def sendOkResponse(client : ExternalRequestClient) : Void
    sendResponse(client, CommonErResponse.new(
      code: ResponseCodes::OK,
      text: nil
    ))
  end

  # Send error response
  protected def sendErrorResponse(client : ExternalRequestClient, code : Int32, text : String? = nil) : Void
    sendResponse(client, CommonErResponse.new(
      code: code,
      text: text
    ))
  end

  def initialize(@commandProcessor : CommandProcessor)
  end  

  # Process contract
  abstract def process(client : ExternalRequestClient, contract : ErContract) : Void
end
