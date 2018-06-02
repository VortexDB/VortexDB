require "./value_type"

# Base entity
class StorageEntity    
    # Entity id
    getter id : Int64

    def initialize(@id)        
    end

    # Calc hash
    def hash
        id
    end

    # Equals
    def ==(obj)
        hash == obj.hash
    end
end

# Class entity
class StorageClass < StorageEntity
    # Название сущности
    getter name : String

    # Parent class
    getter parentClass : StorageClass?

    # Dictionary of class attributes
    @classAttributes = Hash(String, StorageClassAttribute).new

    # Dictionary of instance attributes
    @instanceAttributes = Hash(String, StorageInstanceAttribute).new
    
    def initialize(id, @name, @parentClass)        
        super(id)
    end

    # Check class already has attribute with [name]
    def hasAttribute(name : String) : Bool
        return @classAttributes.has_key?(name) || @instanceAttributes.has_key?(name)
    end

    # Add atribute
    def addAttribute(attribute : StorageAttribute) : StorageClassAttribute
        if hasAttribute(attribute.name)
            raise VortexException.new("Attribute already exists")
        end

        case attribute
        when StorageClassAttribute
            @classAttributes[attribute.name] = attribute 
        when StorageInstanceAttribute
            @instanceAttributes[attribute.name] = attribute
        else
            raise VortexException.new("Unknown attribute type")
        end        
    end   

    # Return class attribute
    def getClassAttribute(name) : StorageClassAttribute?
        return @classAttributes[name]?
    end
end

# Instance entity
class StorageInstance < StorageEntity
    # Parent class
    getter parentClass : StorageClass
    
    def initialize(id, @parentClass)
        super(id)
    end
end

# Entity attribute
class StorageAttribute < StorageEntity
    # Name of attribute
    getter name : String

    # Value type
    getter valueType : ValueType

    def initialize(id, @name, @valueType)
        super(id)
    end
end

# Class attribute
class StorageClassAttribute < StorageAttribute
    # Parent class
    getter parentClass : StorageClass

    def initialize(@parentClass, id, name, valueType)
        super(id, name, valueType)
    end
end

# Instance attribute
class StorageInstanceAttribute < StorageAttribute
    # Parent class
    getter parentClass : StorageClass

    def initialize(@parentClass, id, name, valueType)
        super(id, name, valueType)
    end
end

# Attribute with value
class StorageAttributeWithValue < StorageEntity
    # Attribute info
    getter attribute : StorageAttribute

    # Value to store
    property value : StorableValue

    def initialize(@attribute, @value)
        super(0_i64)
    end
end