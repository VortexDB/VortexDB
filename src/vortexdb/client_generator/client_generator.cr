# Generator target types
enum TargetType
    Crystal
    Dart    
end

# Geneartes client code
abstract class ClientGenerator    
    # Factory constructor
    def self.new(target : TargetType) : ClientGenerator
        case target
        when TargetType::Crystal
            return CrystalClientGenerator.new
        else
            raise VortexException.new("Unknown target")
        end
    end    

    # Generate code
    abstract def generate(storage : Storage) : Void
end