# Process commands
class CommandProcessor
  # Storage for entities
  getter storage : Storage

  def initialize(@storage)
  end

  # Iterate all classes
  def iterateClasses(&block : StorageClass -> _) : Void
    @storage.iterateClasses &block
  end

  # Iterate all instances
  def iterateInstances(&block : StorageInstance -> _) : Void
    @storage.iterateInstances &block
  end

  # Iterate class instances by class name
  def iterateClassInstances(name : String, &block : StorageInstance -> Void) : Void
    parent = @storage.getClassByName(name)
    raise VortexException.new("Class does not exists") if parent.nil?
    @storage.iterateClassInstances(parent, &block)
  end

  # Iterate class attributes
  def iterateClassAttributes(name : String, &block : StorageClassAttribute -> Void) : Void
    parent = @storage.getClassByName(name)
    raise VortexException.new("Class does not exists") if parent.nil?
    parent.iterateClassAttribute(&block)
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

  # Create class/instance attribute
  def createAttribute(parentName : String, name : String, valueTypeStr : String, isClass : Bool) : StorageAttribute
    parent = @storage.getClassByName(parentName).not_nil!
    valueType = ValueType.parse(valueTypeStr)    
    return @storage.createAttribute(parent, name, valueType, isClass)
  end

  # Set attribute value by attribute name
  def setClassAttributeValue(parentName : String, name : String, value : String) : StorageAttributeWithValue
    parent = @storage.getClassByName(parentName).not_nil!
    attr = parent.getAttribute(name, true)
    if attr.nil?
      raise VortexException.new("Attribute does not exists")
    end
    val = ValueParser.toValue(attr.valueType, value)
    @storage.setClassAttributeValue(attr, val)
  end

  # Get class value by attribute name
  def getClassAttributeValue(parentName : String, name : String) : StorageAttributeWithValue?
    parent = @storage.getClassByName(parentName)
    if parent.nil?
      raise VortexException.new("Class #{parentName} does not exists")
    end

    attr = parent.getAttribute(name, true)
    if attr.nil?
      raise VortexException.new("Attribute #{name} does not exists")
    end
    @storage.getClassAttributeValue(attr)
  end

  # Generate client code
  def generateClient(targetName : String) : Void
    targetType = TargetType.parse(targetName)
    generator = ClientGenerator.new(targetType)
    generator.generate(@storage)
  end
end
