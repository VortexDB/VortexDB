require "../common/*"

# Base data log
abstract class LogContract < MsgPackContract
end

# New class
class NewClassLog < LogContract
  mapping(
    id: Int64,
    name: String,
    parentId: Int64?
  )
end

# New instance
class NewInstanceLog < LogContract
  mapping(
    id: Int64,
    parentId: Int64
  )
end

# New attribute log
class NewAttributeLog < LogContract
  mapping(
    id: Int64,
    parentId: Int64,
    name: String,
    valueType: String,
    isClass: Bool
  )
end

# Set attribute value
class SetAttributeValueLog < LogContract
  mapping(
    attributeId: Int64,
    value: String
  )
end
