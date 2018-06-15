require "msgpack"

# Base data log
abstract class MsgPackContract
  # Class creators
  class_property creators = Hash(String, Proc(IO, IO::ByteFormat, MsgPackContract)).new

  abstract def to_msgpack : Bytes

  # Write to IO
  def to_io(io, format)
    data = self.to_msgpack
    io.write_bytes(self.contract.size.to_i32)
    io << self.contract
    io.write_bytes(data.size.to_i64)
    io.write(data)
  end

  # Read from IO
  def self.from_io(io, format)
    nameSize = io.read_bytes(Int32)
    name = io.read_string(nameSize)
    creator = MsgPackContract.creators[name]?
    raise VortexException.new("Unknown contract") if creator.nil?
    return creator.call(io, IO::ByteFormat::SystemEndian)
  end

  # Read body from io
  def self.bodyFromIo(io, format)
    dataSize = io.read_bytes(Int64)
    buff = Bytes.new(dataSize)
    io.read(buff)
    self.from_msgpack(buff)
  end

  # Convert to bytes
  def toBytes : Bytes
    io = IO::Memory.new
    self.to_io(io, IO::ByteFormat::LittleEndian)
    return io.to_slice
  end

  # Create contract from bytes
  def self.fromBytes(bytes : Bytes) : MsgPackContract
    io = IO::Memory.new(bytes, false)
    return self.from_io(io, IO::ByteFormat::SystemEndian)
  end

  macro mapping(**props)
      NAME = {{ @type.name.stringify }}

      getter contract = NAME

      MessagePack.mapping({
          {{props.stringify[1...-1].id}}
      })

      def initialize({{ props.keys.map { |x| ("@" + x.stringify).id }.stringify[1...-1].id }})
      end

      MsgPackContract.creators[NAME] = ->(io : IO, format : IO::ByteFormat) { self.bodyFromIo(io, format).as(MsgPackContract) }
  end
end
