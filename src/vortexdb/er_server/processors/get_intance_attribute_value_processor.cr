# Process get instance attribute value contract
class GetInstanceAttributeValueProcessor < ContractProcessor
  register(GetInstanceAttributeValueErRequest)

  # Process contract
  def processInternal(client : ExternalRequestClient, contract : GetInstanceAttributeValueErRequest) : Void
    attrValue = @commandProcessor.getInstanceAttributeValue(
      contract.parentName,
      contract.instanceId,
      contract.name
    )

    respValue = attrValue ? attrValue.value.to_s : "nil"
    sendResponse(client, GetAttributeValueErResponse.new(
      value: respValue
    ))
  end
end
