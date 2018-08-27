# Process set class attribute value contract
class SetInstanceAttributeValueProcessor < ContractProcessor
    register(SetInstanceAttributeValueErRequest)
  
    # Process contract
    def processInternal(client : ExternalRequestClient, contract : SetInstanceAttributeValueErRequest) : Void
      @commandProcessor.setInstanceAttributeValue(
        contract.instanceId,        
        contract.parentName,
        contract.name,
        contract.value
      )
      sendOkResponse(client)
    end
  end