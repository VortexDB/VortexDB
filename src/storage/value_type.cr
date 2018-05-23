# Type for value
enum ValueType
    # Int64 value
    Int,
    # String value
    String,
    # Double value
    Double
end

# Extension for string
class String
    # Converts string to value type
    def toValueType
        case self
        when "int"
            return ValueType::Int
        when "string"
            return ValueType::String
        when "double"
            return ValueType::Double
        else
            raise VortexException.new("Unknown value type")
        end
    end
end