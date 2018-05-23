# Type for value
enum ValueType
    VInt,
    VString,
    VDouble
end

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

    def initialize(@name)
    end
end