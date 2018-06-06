# Extended contract
abstract class ErContract < MsgPackContract
end

# Common response with result code
class CommonErContract < ErContract
  mapping(
    code: Int32,
    text: String
  )
end

# New class
class NewClassErContract < ErContract
  mapping(
    name: String,
    parentName: String?
  )
end

# New instance
class NewClassErContract < ErContract
end

# New attribute
class NewAttributeErContract < ErContract
end

# Set value
class SetValueErContract < ErContract
end
