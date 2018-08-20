# Process new instance contract
class NewInstanceProcessor < ContractProcessor
  register(NewInstanceErRequest)

  # Process contract
  def processInternal(client : ExternalRequestClient, contract : NewInstanceErRequest) : Void
    inst = @commandProcessor.createInstance(contract.parentName)
    pp inst
    sendOkResponse(client)
  end
end
