# Client generator factory for storing client generators
abstract class ClientGeneratorFactory
    class_property knownGenerators = Hash(String, ClientGenerator).new
    
    def self.get(name : String) : ClientGenerator
        knownGenerators[name]?
    end
end