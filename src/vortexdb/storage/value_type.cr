# Value that can be stored
alias StorableValue = Int64 | Float64 | String

# Type for value
enum ValueType
  # Int64 value
  Int,
  # Double value
  Double,
  # String value
  String
end

# Extension for string
class String
  # Convert string to value type
  def toValueType : ValueType
    return ValueType.parse(self)
  end

  # Convert string to value
  def toValue(valueType : ValueType) : StorableValue
    case valueType
    when ValueType::Int
      return self.to_i64
    when ValueType::String
      return self
    when ValueType::Double
      self.to_f64
    else
      raise VortexException.new("Unknown value type")
    end
  end
end
