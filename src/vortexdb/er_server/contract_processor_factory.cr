class ContractProcessorFactory
  class_property knownProcessors = Hash(ErContract.class, ContractProcessor.class).new
  class_property cacheProcessors = Hash(ErContract.class, ContractProcessor).new

  # Get contract processor by contract class
  def self.get(contractClass : ErContract.class, commandProcessor : CommandProcessor) : ContractProcessor?    
    processor = ContractProcessorFactory.cacheProcessors[contractClass]?    
    return processor unless processor.nil?
    processorClass = knownProcessors[contractClass]
    if processorClass
      processor = processorClass.new(commandProcessor)
      ContractProcessorFactory.cacheProcessors[contractClass] = processor
      return processor
    end
  end
end
