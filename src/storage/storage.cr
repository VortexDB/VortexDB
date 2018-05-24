require "./contracts"

# In-memory storage for entities
class Storage
    # Classes
    @storageClasses : Hash(String, StorageClass)

    # Values for attributes
    @attributeValues : Hash(StorageAttribute, StorageAttributeWithValue)
        
    def initialize
        @storageClasses = Hash(String, StorageClass).new
        @attributeValues = Hash(StorageAttribute, StorageAttributeWithValue).new
    end

    # Returns class by name
    def getClassByName(name : String) : StorageClass?
        return @storageClasses[name]?
    end

    # Creates class for storage and returns it
    def createClass(name : String, parent : StorageClass?) : StorageClass
        nclass = StorageClass.new(name, parent)
        @storageClasses[nclass.name] = nclass
        return nclass
    end

    # Create new instance
    def createInstance(name : String, parentClass : StorageClass) : StorageInstance
    end

    # Creates new class attribute
    def createClassAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageClassAttribute        
        return parent.createClassAttribute(name, valueType)
    end

    # Set attribute value by id
    def setAttributeValue(attribute : StorageAttribute, value : StorableValue) : StorageAttributeWithValue
        # TODO: check attribute type
        attrWithValue = @attributeValues[attribute]?
        if attrWithValue.nil?
            attrWithValue = StorageAttributeWithValue.new(attribute, value)
        else
            attrWithValue.value = value
        end
        attrWithValue
    end

    # Creates new instance attribute
    # def createInstanceAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageAttribute
    #     nclass = StorageClass.new(name, parent)
    #     return nclass.createClassAttribute(name, valueType)
    # end
end