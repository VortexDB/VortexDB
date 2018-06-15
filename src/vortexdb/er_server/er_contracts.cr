# Codes for response
module ResponseCodes
  OK             =   0
  INTERNAL_ERROR = 255
end

# Extended contract
abstract class ErContract < MsgPackContract
end

# Common response with result code
class CommonErResponse < ErContract
  mapping(
    code: Int32,
    text: String?
  )
end

# New class request
class NewClassErRequest < ErContract
  mapping(
    name: String,
    parentName: String?
  )
end

# New instance request
class NewInstanceErRequest < ErContract
  mapping(
    parentName: String
  )
end

# New attribute request
class NewAttributeErRequest < ErContract
  mapping(
    name: String,
    parentName: String,
    valueType: String,
    isClass: Bool
  )
end

# Set attribute value
class SetAttributeValueErRequest < ErContract
  mapping(
    name: String,
    parentName: String,
    value: String,
    isClass: Bool
  )
end

# Get attribute value request
class GetAttributeValueErRequest < ErContract
  mapping(
    name: String,
    parentName: String,
    isClass: Bool
  )
end

# Get attribute value request
class GetAttributeValueErResponse < ErContract
  mapping(
    value: String
  )
end
