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

# New class request
class NewClassErRequest < ErContract
  mapping(
    name: String,
    parentName: String?
  )
end

# New class response
class NewClassErResponse < ErContract
  mapping(
    id: Int64,
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

# New instance response
class NewInstanceErResponse < ErContract
  mapping(
    id: Int64,
    parentName: String
  )
end

# New attribute
class NewAttributeErContract < ErContract
end

# Set value
class SetValueErContract < ErContract
end
