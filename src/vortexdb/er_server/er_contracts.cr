# Extended contract
abstract class ErContract < MsgPackContract
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
