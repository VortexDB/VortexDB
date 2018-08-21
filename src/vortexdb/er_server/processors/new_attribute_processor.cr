# Process new attribute contract
class NewAttributeProcessor < ContractProcessor
  register(NewAttributeErRequest)

  # Process contract
  def processInternal(client : ExternalRequestClient, contract : NewAttributeErRequest) : Void
    attr = @commandProcessor.createAttribute(contract.parentName, contract.name, contract.valueType, contract.isClass)
    pp attr
    sendOkResponse(client)
  end
end
