require "./contracts"

# Хранилище
class Storage
    # Конструктор
    def initialize
    end

    # Создаёт класс
    def createClass(name : String, parent : StorageClass) : StorageClass
    end

    # Создаёт сущность
    def createInstance(name : String, parentClass : StorageClass) : StorageInstance
    end

    # Создаёт аттрибут
    def createAttribute() : StorageAttribute
    end
end