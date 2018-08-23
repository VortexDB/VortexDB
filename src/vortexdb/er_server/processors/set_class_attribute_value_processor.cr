# Process set class attribute value contract
class SetClassAttributeValueProcessor < ContractProcessor
  register(SetClassAttributeValueErRequest)

  # Process contract
  def processInternal(client : ExternalRequestClient, contract : SetClassAttributeValueErRequest) : Void
    @commandProcessor.setClassAttributeValue(
      contract.parentName,
      contract.name,
      contract.value
    )
    sendOkResponse(client)
  end
end
