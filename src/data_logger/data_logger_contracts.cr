require "msgpack"

# Base data log
abstract class DataLog
  macro mapping(**props)
    NAME = {{ @type.name.stringify }}    

    getter contract = NAME

    MessagePack.mapping({
        {{props.stringify[1...-1].id}}
    })

    def initialize({{ props.keys.map { |x| ("@" + x.stringify).id }.stringify[1...-1].id }})
    end
  end

  # Write to IO
  def to_io(io, format)
    data = self.to_msgpack
    io.write_bytes(data.size.to_i64)
    io.write(data)
  end  
end

# New class log
class NewClassLog < DataLog
  mapping(
    id: Int64,
    name: String,
    parentName: String?
  )

  # Read from IO
  def self.from_io(io, format) : self
    dataSize = io.read_bytes(Int64)
    buff = Bytes.new(dataSize)
    io.read(buff)
    NewClassLog.from_msgpack(buff)
  end
end
