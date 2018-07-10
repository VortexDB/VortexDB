require "benchmark"
require "./storage_contracts"
require "../data_logger/data_logger_contracts"

include VortexCommon

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

  # Instances. Class -> Hash(InstanceId, Instance)
  @storageInstances : Hash(StorageClass, Hash(Int64, StorageInstance))

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
      parent = classesById[cls.parentId]?
      cls = StorageClass.new(cls.id, cls.name, parent)
      @storageClasses[cls.name] = cls
      classesById[cls.id] = cls
      classMaxId = cls.id if classMaxId < cls.id
    end
    Storage.classCounter = classMaxId.to_i64

    instCount = @database.getInstanceCount
    Storage.instanceCounter = instCount

    attributesById = Hash(Int64, StorageAttribute).new
    attrMaxId = 0
    @database.allAttributes do |attr|
      attrMaxId = attr.id if attrMaxId < attr.id
      case attr
      when DBAttribute
        cls = classesById[attr.parentId]?
        next if cls.nil?
        valType = ValueType.parse(attr.valueType)
        nattr = if attr.isClass
                  StorageClassAttribute.new(cls, attr.id, attr.name, valType)
                else
                  StorageInstanceAttribute.new(cls, attr.id, attr.name, valType)
                end

        cls.addAttribute(nattr)
        attributesById[attr.id] = nattr
      else
        raise VortexException.new("Unknown attribute type")
      end
    end
    Storage.attributeCounter = attrMaxId.to_i64

    @database.allValues do |attrValue|
      attr = attributesById[attrValue.attributeId]?
      if !attr.nil?
        @attributeValues[attr] = StorageAttributeWithValue.new(
          attribute: attr,
          value: ValueParser.toValue(attr.valueType, attrValue.value)
        )
      end
    end
  end

  def initialize(@database, @dataLogWriter)
    @storageClasses = Hash(String, StorageClass).new
    @storageInstances = Hash(StorageClass, Hash(Int64, StorageInstance)).new
    @attributeValues = Hash(StorageAttribute, StorageAttributeWithValue).new

    b = Benchmark.realtime { readEntities }
    puts "Read entities: #{b}"
  end

  # Iterate all classes
  def iterateClasses(&block : StorageClass -> _) : Void
    @storageClasses.values.each do |x|
      yield x
    end
  end

  # Iterate all instances
  def iterateInstances(&block : StorageInstance -> _) : Void
    @storageInstances.values.each do |x|
      x.values.each do |instance|
        yield instance
      end
    end
  end

  # Iterate class instances classes
  def iterateClassInstances(parentClass : StorageClass, &block : StorageInstance -> _) : Void
    instances = @storageInstances[parentClass]?
    if instances
      instances.values.each do |x|
        yield x
      end
    end
  end

  # Returns class by name
  def getClassByName(name : String) : StorageClass?
    return @storageClasses[name]?
  end

  # Get instance by id
  def getInstanceById(parentClass : StorageClass, id : Int64) : StorageInstance?
    instances = @storageInstances[parentClass]?
    instance = instances.try &.[id]?
    return instance
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
    instances = @storageInstances[parentClass]? || Hash(Int64, StorageInstance).new
    if instances.empty?
      @storageInstances[parentClass] = instances
    end

    instances[ninstance.id] = ninstance
    @dataLogWriter.write(
      NewInstanceLog.new(
        id: ninstance.id,
        parentId: parentClass.id
      )
    )
    return ninstance
  end

  # Creates new class attribute
  def createAttribute(parent : StorageClass, name : String, valueType : ValueType, isClass : Bool) : StorageAttribute
    Storage.attributeCounter += 1_i64
    nattr = if isClass
              StorageClassAttribute.new(parent, Storage.attributeCounter, name, valueType)
            else
              StorageInstanceAttribute.new(parent, Storage.attributeCounter, name, valueType)
            end

    parent.addAttribute(nattr)

    @dataLogWriter.write(
      NewAttributeLog.new(
        id: nattr.id,
        parentId: nattr.parentClass.id,
        name: nattr.name,
        valueType: nattr.valueType.to_s,
        isClass: isClass
      )
    )
    return nattr
  end

  # Set attribute value by id
  def setAttributeValue(attribute : StorageAttribute, value : VortexValue) : StorageAttributeWithValue
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
