require "./storage/storage"

# Обрабатывает команды
class CommandProcessor
    # Storage for entities
    getter storage : Storage

    def initialize(@storage)        
    end

    # Creates new class
    def createClass(name : String, parentId : Int64?) : StorageClass
        parent = @storage.getClassById(parentId) if !parentId.nil?
        return @storage.createClass(name, parent)
    end

    # Create new class attribute
    def createClassAttribute(parentId : Int64, name : String, valueTypeStr : String) : StorageAttribute
        parent = @storage.getClassById(parentId) if !parentId.nil?
        vtype = valueTypeStr.toValueType
        return @storage.createClassAttribute(parent, name, vtype)
    end    
end