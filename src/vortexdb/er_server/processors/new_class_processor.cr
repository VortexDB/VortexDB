# Process new class contract
class NewClassProcessor < ContractProcessor
  register(NewClassErRequest)

  # Process contract
  def processInternal(client : ExternalRequestClient, contract : NewClassErRequest) : Void
    cls = @commandProcessor.createClass(contract.name, contract.parentName)
    pp cls
    sendOkResponse(client)
  end
end
