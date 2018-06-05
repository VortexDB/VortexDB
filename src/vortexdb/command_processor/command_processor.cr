# Process commands
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

    # Create new instance
    def createInstance(parentName : String) : StorageInstance
        parent = @storage.getClassByName(parentName)
        raise VortexException.new("Class does not exists") if parent.nil?
        return @storage.createInstance(parent)
    end

    # Create new class attribute
    def createClassAttribute(parentName : String, name : String, valueTypeStr : String) : StorageAttribute
        parent = @storage.getClassByName(parentName).not_nil!
        valueType = valueTypeStr.toValueType
        return @storage.createClassAttribute(parent, name, valueType)
    end  
    
    # Create new instance attribute
    def createInstanceAttribute(instanceId : Int64, name : String, valueTypeStr : String) : StorageAttribute
        instance = storage.getInstanceById(instanceId)
        raise VortexException.new("Instance does not exists") if instance.nil?
        valueType = valueTypeStr.toValueType
        return @storage.createInstanceAttribute(instance.parentClass, instanceId, name, valueType)  
    end

    # Set class attribute value by attribute name
    def setClassAttributeValueByName(parentName : String, name : String, value : String) : StorageAttributeWithValue
        parent = @storage.getClassByName(parentName).not_nil!
        attr = parent.getClassAttribute(name)
        if attr.nil?
            raise VortexException.new("Attribute does not exists")
        end
        val = value.toValue(attr.valueType)        
        @storage.setAttributeValue(attr, val)
    end

    # Get class value by attribute name
    def getClassAttributeValueByName(parentName : String, name : String) : StorageAttributeWithValue?
        parent = @storage.getClassByName(parentName).not_nil!        
        attr = parent.getClassAttribute(name)
        if attr.nil?
            raise VortexException.new("Attribute does not exists")
        end
        @storage.getAttributeValue(attr)
    end        
end