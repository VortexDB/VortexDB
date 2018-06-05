require "benchmark"
require "./storage_contracts"
require "../data_logger/data_logger_contracts"

# In-memory storage for entities
class Storage
  # Counter for classes
  class_property classCounter : Int64 = 0_i64

  # Counter for instances
  class_property instanceCounter : Int64 = 0_i64

  # Counter for attributes
  class_property attributeCounter : Int64 = 0_i64
    
  # Classes
  @storageClasses : Hash(String, StorageClass)

  # Instances
  @storageInstances : Hash(Int64, StorageInstance)

  # Values for attributes
  @attributeValues : Hash(StorageAttribute, StorageAttributeWithValue)

  # For working with database
  getter database : Database

  # For writing data to log
  getter dataLogWriter : DataLogWriter

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
    Storage.classCounter = classMaxId.to_i64

    attributesById = Hash(Int64, StorageAttribute).new

    attrMaxId = 0
    @database.allAttributes do |attr|
      attrMaxId = attr.id if classMaxId < attr.id
      case attr
      when DBClassAttribute
        cls = classesById[attr.parentId]?
        next if cls.nil?
        nattr = StorageClassAttribute.new(cls, attr.id, attr.name, attr.valueType.toValueType)
        cls.addAttribute(nattr)
        attributesById[attr.id] = nattr        
      when DBInstanceAttribute
      else
        raise VortexException.new("Unknown attribute type")
      end
    end
    Storage.attributeCounter = attrMaxId.to_i64

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
    @storageInstances = Hash(Int64, StorageInstance).new
    @attributeValues = Hash(StorageAttribute, StorageAttributeWithValue).new

    b = Benchmark.realtime { readEntities }
    puts "Read entities: #{b}"
  end

  # Returns class by name
  def getClassByName(name : String) : StorageClass?
    return @storageClasses[name]?
  end

  # Get instance by id
  def getInstanceById(id : Int64) : StorageInstance?
    return @storageInstances[id]?
  end

  # Creates class for storage and returns it
  def createClass(name : String, parent : StorageClass?) : StorageClass
    if !getClassByName(name).nil?
      raise VortexException.new("Class already exists")
    end

    Storage.classCounter += 1_i64
    nclass = StorageClass.new(Storage.classCounter, name, parent)
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
  def createInstance(parentClass : StorageClass) : StorageInstance
    Storage.instanceCounter += 1_i64
    ninstance = StorageInstance.new(Storage.instanceCounter, parentClass)
    @storageInstances[ninstance.id] = ninstance
    @dataLogWriter.write(
      NewInstanceLog.new(
        id: ninstance.id,        
        parentId: parentClass.id
      )
    )
    return ninstance
  end

  # Creates new class attribute
  def createClassAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageClassAttribute
    Storage.attributeCounter += 1_i64
    nattr = StorageClassAttribute.new(parent, Storage.attributeCounter, name, valueType)
    parent.addAttribute(nattr)

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

  # Create instance attribute
  def createInstanceAttribute(parent : StorageClass, instanceId : Int64, name : String, valueType : ValueType) : StorageInstanceAttribute
    Storage.attributeCounter += 1_i64
    nattr = StorageInstanceAttribute.new(parent, Storage.attributeCounter, name, valueType)
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
end
