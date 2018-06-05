require "msgpack"

# Base data log
abstract class MsgPackContract
    # Class creators
    class_property creators = Hash(String, Proc(IO, IO::ByteFormat, MsgPackContract)).new
    
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

    # Convert to bytes
    def toBytes : Bytes
        self.to_msgpack
    end

    # Create contract from bytes
    def self.fromBytes(bytes : Bytes) : MsgPackContract
        io = IO::Memory.new(bytes, false)
        nameSize = io.read_bytes(Int32)
        name = io.read_string(nameSize)

        creator = MsgPackContract.creators[name]?
        raise VortexException.new("Unknown contract") if creator.nil?
        return creator.call(io, IO::ByteFormat::SystemEndian)
    end
  
  macro mapping(**props)
      NAME = {{ @type.name.stringify }}

      getter contract = NAME

      MessagePack.mapping({
          {{props.stringify[1...-1].id}}
      })

      def initialize({{ props.keys.map { |x| ("@" + x.stringify).id }.stringify[1...-1].id }})
      end

      MsgPackContract.creators[NAME] = ->(io : IO, format : IO::ByteFormat) { self.from_io(io, format).as(MsgPackContract) }
  end
end
