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

# Database class
class DBClass < DatabaseContract
    mapping(
        id: Int64,
        name: String,
        parentId: Int64?
    )
end

# Base attribute
abstract class DBAttribute < DatabaseContract   
    # Returns id of attribute 
    abstract def id : Int64

    # Returns name of attribute 
    abstract def name : String
end

# Database class attribute
class DBClassAttribute < DBAttribute
    mapping(
        id: Int64,
        name: String,
        parentId: Int64,
        valueType: String
    )
end

# Database instance attribute
class DBInstanceAttribute < DBAttribute
    mapping(
        id: Int64,
        name: String,
        parentId: Int64,
        valueType: String
    )
end

# Attribute value
class DBAttributeValue < DatabaseContract
    mapping(
        attributeId: Int64,
        value: String
    )
end