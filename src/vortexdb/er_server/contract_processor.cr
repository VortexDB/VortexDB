# Abstract contract processor
abstract class ContractProcessor
  macro register(contractClass)
  	ContractProcessorFactory.knownProcessors[{{ contractClass }}] = {{ @type }}
  end

  # For processing contract
  @commandProcessor : CommandProcessor

  def initialize(@commandProcessor : CommandProcessor)
  end

  # Process contract
  abstract def process(client : ExternalRequestClient, contract : ErContract) : Void
end
