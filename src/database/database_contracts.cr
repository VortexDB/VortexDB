require "db"

# For writing data to database
class DatabaseContract
    macro mapping(**props)
        NAME = {{ @type.name.stringify }}    
    
        getter contract = NAME
    
        DB.mapping({
            {{props.stringify[1...-1].id}}
        })
    
        def initialize({{ props.keys.map { |x| ("@" + x.stringify).id }.stringify[1...-1].id }})
        end
      end
end

# New class contract
class DBClass < DatabaseContract
    mapping(
        id: Int64,
        name: String,
        parentId: Int64?
    )
end