require "./value_type"

# Base entity
class StorageEntity
    class_property counter : Int64 = 0_i64

    # Entity id
    getter id : Int64

    def initialize
        @id = StorageEntity.counter
        StorageEntity.counter += 1
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
    getter classAttributes : Hash(String, StorageClassAttribute)
    
    def initialize(@name, @parentClass)
        @classAttributes = Hash(String, StorageClassAttribute).new
        super()
    end

    # Create class attribute
    def createClassAttribute(name : String, valueType : ValueType) : StorageClassAttribute
        if @classAttributes.has_key?(name)
            raise VortexException.new("Attribute already exists")
        end

        nattr = StorageClassAttribute.new(self, name, valueType)
        @classAttributes[name] = nattr
        return nattr
    end

    # Return class attribute
    def getClassAttribute(name) : StorageClassAttribute?
        classAttributes[name]?
    end
end

# Instance entity
class StorageInstance < StorageEntity    
    # Parent class
    getter parentClass : StorageClass
    
    def initialize(@parentClass)
        super()
    end
end

# Entity attribute
class StorageAttribute < StorageEntity
    # Name of attribute
    getter name : String

    # Value type
    getter valueType : ValueType

    def initialize(@name, @valueType)
        super()
    end
end

# Class attribute
class StorageClassAttribute < StorageAttribute
    # Parent class
    getter parentClass : StorageClass
    
    def initialize(@parentClass, name, valueType)
        super(name, valueType)
    end
end

# Attribute with value
class StorageAttributeWithValue
    # Attribute info
    getter attribute : StorageAttribute

    # Value to store
    property value : StorableValue

    def initialize(@attribute, @value)        
    end
end