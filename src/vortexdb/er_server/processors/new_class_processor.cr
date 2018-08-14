# Process new class contract
class NewClassProcessor < ContractProcessor
  register(NewClassErRequest)

  def process(client : ExternalRequestClient, contract : ErContract) : Void
  end
end
