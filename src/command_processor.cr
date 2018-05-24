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

    # Set class attribute value by attr name
    def setClassAttributeValueByName(parentName : String, name : String, value : String) : StorageAttributeWithValue
        parent = @storage.getClassByName(parentName).not_nil!
        attr = parent.getClassAttribute(name)
        if attr.nil?
            raise VortexException.new("Attribute does not exists")
        end
        val = value.toValue(attr.valueType)        
        @storage.setAttributeValue(attr, val)
    end
end