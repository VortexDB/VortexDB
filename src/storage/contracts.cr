# Сущность
class StorageEntity
    # Идентификатор сущности
    getter id : Int64

    # Название сущности
    getter name : String

    # Конструктор
    def initialize(@id, @name)        
    end
end

# Описание класса
class StorageClass < StorageEntity
    # Класс владелец
    getter parentClass : StorageClass

    # Конструктор
    def initialize(id, name, @parentClass)
        super(id, name)
    end
end

# Описание сущности
class StorageInstance < StorageEntity
    # Класс владелец
    getter parentClass : StorageClass

    # Конструктор
    def initialize(id, name, @parentClass)
        super(id, name)
    end
end

# Описание атрибута
class StorageAttribute < StorageEntity
    # Конструктор
    def initialize(id, name)
        super(id, name)
    end
end