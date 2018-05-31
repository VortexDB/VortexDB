require "msgpack"

# Base data log
abstract class LogContract
  # Class creators
  class_property creators = Hash(String, Proc(IO, IO::ByteFormat, LogContract)).new

  macro mapping(**props)
    NAME = {{ @type.name.stringify }}    

    getter contract = NAME

    MessagePack.mapping({
        {{props.stringify[1...-1].id}}
    })

    def initialize({{ props.keys.map { |x| ("@" + x.stringify).id }.stringify[1...-1].id }})
    end

    LogContract.creators[NAME] = ->(io : IO, format : IO::ByteFormat) { self.from_io(io, format).as(LogContract) }
  end

  # Write to IO
  def to_io(io, format)
    data = self.to_msgpack
    io.write_bytes(data.size.to_i64)
    io.write(data)
  end  

  # Read from IO
  def self.from_io(io, format)
    dataSize = io.read_bytes(Int64)
    buff = Bytes.new(dataSize)
    io.read(buff)
    self.from_msgpack(buff)
  end
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
    name: String,
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
    parentId: Int64,
    name: String,
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
