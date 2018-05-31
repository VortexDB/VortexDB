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
    # Counter for class id
    class_property counter : Int64 = 0_i64

    # Название сущности
    getter name : String

    # Parent class
    getter parentClass : StorageClass?

    # Dictionary of class attributes
    getter classAttributes = Hash(String, StorageClassAttribute).new

    # Dictionary of instance attributes
    getter instanceAttributes = Hash(String, StorageInstanceAttribute).new

    def initialize(@name, @parentClass)
        StorageClass.counter += 1
        super(StorageClass.counter)
    end

    def initialize(id, @name, @parentClass)        
        super(id)
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

    # Create class attribute with id
    def createClassAttribute(id : Int64, name : String, valueType : ValueType) : StorageClassAttribute
        # TODO: refactor
        if @classAttributes.has_key?(name)
            raise VortexException.new("Attribute already exists")
        end

        nattr = StorageClassAttribute.new(self, id, name, valueType)
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
    # Instance name
    getter name : String

    # Parent class
    getter parentClass : StorageClass
    
    def initialize(@name, @parentClass)
        super()
    end
end

# Entity attribute
class StorageAttribute < StorageEntity
     # Counter for attribute id
     class_property counter : Int64 = 0_i64

    # Name of attribute
    getter name : String

    # Value type
    getter valueType : ValueType

    def initialize(@name, @valueType)
        StorageAttribute.counter += 1
        super(StorageAttribute.counter)
    end

    def initialize(id, @name, @valueType)
        super(id)
    end
end

# Class attribute
class StorageClassAttribute < StorageAttribute
    # Parent class
    getter parentClass : StorageClass
    
    def initialize(@parentClass, name, valueType)
        super(name, valueType)
    end

    def initialize(@parentClass, id, name, valueType)
        super(id, name, valueType)
    end
end

# Instance attribute
class StorageInstanceAttribute < StorageAttribute
    # Parent class
    getter parentClass : StorageClass

    def initialize(@parentClass, name, valueType)
        super(name, valueType)
    end

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