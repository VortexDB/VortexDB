require "./value_type"

# Base entity
class StorageEntity
end

# Class entity
class StorageClass < StorageEntity
    # Название сущности
    getter name : String

    # Parent class
    getter parentClass : StorageClass?

    # Dictionary of class attributes
    getter classAttributes : Hash(String, StorageAttribute)
    
    def initialize(@name, @parentClass)
        @classAttributes = Hash(String, StorageAttribute).new
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
end

# Instance entity
class StorageInstance < StorageEntity
    # Instance id
    getter id : Int64

    # Parent class
    getter parentClass : StorageClass
    
    def initialize(@id, @parentClass)
        super(id)
    end
end

# Entity attribute
class StorageAttribute < StorageEntity
    # Name of attribute
    getter name : String

    # Value type
    getter valueType : ValueType

    def initialize(@name, @valueType)
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