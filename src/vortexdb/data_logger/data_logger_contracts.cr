require "../common/*"

# Base data log
abstract class LogContract < MsgPackContract
  register
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

# New class attribute
class NewClassAttributeLog < LogContract
  mapping(
    id: Int64,
    parentId: Int64,
    name: String,
    valueType: String    
  )
end

# New class attribute
class NewInstanceAttributeLog < LogContract
  mapping(
    id: Int64,
    name: String,
    parentId: Int64,
    valueType: String
  )
end

# Set attribute value
class SetAttributeValueLog < LogContract
  mapping(
    attributeId: Int64,
    value: String
  )
end
