require "./storage/storage"

# Обрабатывает команды
class CommandProcessor
    # Storage for entities
    getter storage : Storage

    def initialize(@storage)        
    end

    # Creates new class
    def createClass(name : String, parentName : String?) : StorageClass
        parent = @storage.getClassByName(parentName) if !parentName.nil?
        return @storage.createClass(name, parent)
    end

    # Create new class attribute
    def createClassAttribute(parentName : String, name : String, valueTypeStr : String) : StorageAttribute
        parent = @storage.getClassByName(parentName).not_nil!
        vtype = valueTypeStr.toValueType
        return @storage.createClassAttribute(parent, name, vtype)
    end    
end