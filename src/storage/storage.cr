require "./storage_contracts"
require "../data_logger/data_logger_contracts"

# In-memory storage for entities
class Storage
    # For writing data to log
    getter dataLogWriter : DataLogWriter

    # Classes
    @storageClasses : Hash(String, StorageClass)

    # Values for attributes
    @attributeValues : Hash(StorageAttribute, StorageAttributeWithValue)
        
    def initialize(@dataLogWriter)
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
        @dataLogWriter.write(
            NewClassLog.new(
                id: nclass.id,
                name: nclass.name,
                parentId: parent.try &.id
            )
        )
        return nclass
    end

    # Create new instance
    def createInstance(name : String, parentClass : StorageClass) : StorageInstance
    end

    # Creates new class attribute
    def createClassAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageClassAttribute        
        nattr = parent.createClassAttribute(name, valueType)
        @dataLogWriter.write(
            NewClassAttributeLog.new(
                id: nattr.id,
                parentName: nattr.parentClass.name,
                name: nattr.name,
                valueType: nattr.valueType.to_s
            )
        )
        return nattr
    end

    # Set attribute value by id
    def setAttributeValue(attribute : StorageAttribute, value : StorableValue) : StorageAttributeWithValue
        attrWithValue = @attributeValues[attribute]?
        if attrWithValue.nil?
            attrWithValue = StorageAttributeWithValue.new(attribute, value)
            @attributeValues[attribute] = attrWithValue
        else
            attrWithValue.value = value
        end
        attrWithValue
    end

    # Get attribute value
    def getAttributeValue(attribute : StorageAttribute) : StorageAttributeWithValue?        
        @attributeValues[attribute]?
    end

    # Creates new instance attribute
    # def createInstanceAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageAttribute
    #     nclass = StorageClass.new(name, parent)
    #     return nclass.createClassAttribute(name, valueType)
    # end
end