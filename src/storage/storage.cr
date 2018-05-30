require "benchmark"
require "./storage_contracts"
require "../data_logger/data_logger_contracts"

# In-memory storage for entities
class Storage
    # For working with database
    getter database : Database

    # For writing data to log
    getter dataLogWriter : DataLogWriter

    # Classes
    @storageClasses : Hash(String, StorageClass)

    # Values for attributes
    @attributeValues : Hash(StorageAttribute, StorageAttributeWithValue)
    
    # Read entities from database
    private def readEntities        
        classesById = Hash(Int64, StorageClass).new

        classMaxId = 0
        @database.allClasses.each do |cls|
            cls = StorageClass.new(cls.id, cls.name, nil)
            @storageClasses[cls.name] = cls
            classesById[cls.id] = cls
            classMaxId = cls.id if classMaxId < cls.id
        end
        StorageClass.counter = 1_i64 + classMaxId.to_i64

        attributesById = Hash(Int64, StorageAttribute).new

        attrMaxId = 0
        @database.allAttributes do |attr|
            attrMaxId = attr.id if classMaxId < attr.id
            case attr
            when DBClassAttribute
                cls = classesById[attr.parentId]?                
                if !cls.nil?
                    nattr = cls.createClassAttribute(attr.id, attr.name, ValueType::String)
                    attributesById[attr.id] = nattr                    
                end
            when DBInstanceAttribute

            else
                raise VortexException.new("Unknown attribute type")
            end
        end
        StorageAttribute.counter = 1_i64 + attrMaxId.to_i64

        @database.allValues do |value|
            attr = attributesById[value.attributeId]?
            if !attr.nil?
                @attributeValues[attr] = StorageAttributeWithValue.new(
                    attribute: attr,
                    value: value.value.toValue(attr.valueType)
                )
            end
        end        
    end

    def initialize(@database, @dataLogWriter)
        @storageClasses = Hash(String, StorageClass).new
        @attributeValues = Hash(StorageAttribute, StorageAttributeWithValue).new

        b = Benchmark.realtime { readEntities }
        puts "Read entities: #{b}"
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
                parentId: nattr.parentClass.id,
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

        @dataLogWriter.write(
            SetAttributeValueLog.new(
                attributeId: attribute.id,
                value: value.to_s
            )
        )

        return attrWithValue
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