# Type for value
enum ValueType
    VInt,
    VString,
    VDouble
end

# Base entity
class StorageEntity
    # Идентификатор сущности
    getter id : Int64

    # Название сущности
    getter name : String

    # Конструктор
    def initialize(@id, @name)        
    end
end

# Class entity
class StorageClass < StorageEntity
    # Класс владелец
    getter parentClass : StorageClass?

    # Конструктор
    def initialize(id, name, @parentClass)
        super(id, name)
    end
end

# Instance entity
class StorageInstance < StorageEntity
    # Parent class
    getter parentClass : StorageClass
    
    def initialize(id, name, @parentClass)
        super(id, name)
    end
end

# Entity attribute
class StorageAttribute < StorageEntity
    def initialize(id, name)
        super(id, name)
    end
end