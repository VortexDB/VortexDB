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
end

# New class log
class NewClassLog < DataLog
  mapping(
    id: Int64,
    name: String,
    parentName: String?
  )
end
