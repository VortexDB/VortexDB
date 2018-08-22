# Process get class attribute value contract
class GetClassAttributeValueProcessor < ContractProcessor
  register(GetClassAttributeValueErRequest)

  # Process contract
  def processInternal(client : ExternalRequestClient, contract : GetClassAttributeValueErRequest) : Void
    attrValue = @commandProcessor.getClassAttributeValue(
      contract.parentName,
      contract.name
    )

    respValue = attrValue ? attrValue.value.to_s : "nil"
    sendResponse(client, GetAttributeValueErResponse.new(
      value: respValue
    ))
  end
end
