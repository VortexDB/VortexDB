include VortexCommon

# Base entity
class StorageEntity
  # Entity id
  getter id : Int64

  def initialize(@id)
  end

  # Calc hash
  def hash
    id
  end

  # Equals
  def ==(obj)
    hash == obj.hash
  end
end

# Class entity
class StorageClass < StorageEntity
  # Название сущности
  getter name : String

  # Parent class
  getter parentClass : StorageClass?

  # Return parent name
  def parentName : String
    if parent = @parentClass
      parent.name
    else
      ""
    end
  end

  # Dictionary of class attributes
  @classAttributes = Hash(String, StorageClassAttribute).new

  # Dictionary of instance attributes
  @instanceAttributes = Hash(String, StorageInstanceAttribute).new

  def initialize(id, @name, @parentClass)
    super(id)
  end

  # Check class already has attribute with [name]
  def hasAttribute(name : String) : Bool
    return @classAttributes.has_key?(name) || @instanceAttributes.has_key?(name)
  end

  # Add atribute
  def addAttribute(attribute : StorageAttribute) : StorageAttribute
    if hasAttribute(attribute.name)
      raise VortexException.new("Attribute already exists")
    end

    case attribute
    when StorageClassAttribute
      @classAttributes[attribute.name] = attribute
    when StorageInstanceAttribute
      @instanceAttributes[attribute.name] = attribute
    else
      raise VortexException.new("Unknown attribute type")
    end
  end

  # Return class attribute
  def getAttribute(name : String, isClass : Bool) : StorageAttribute?
    attr = if isClass
             @classAttributes[name]?
           else
             @instanceAttributes[name]?
           end

    return attr
  end

  # Iterate all class attributes
  def iterateClassAttribute(&block : StorageClassAttribute -> _) : Void
    @classAttributes.each do |k, v|
      yield v
    end
  end

  # Iterate all instance attributes
  def iterateInstanceAttribute(&block : StorageInstanceAttribute -> _) : Void
    @instanceAttributes.each do |k, v|
      yield v
    end
  end
end

# Instance entity
class StorageInstance < StorageEntity
  # Parent class
  getter parentClass : StorageClass

  def initialize(id, @parentClass)
    super(id)
  end
end

# Entity attribute
class StorageAttribute < StorageEntity
  # Name of attribute
  getter name : String

  # Value type
  getter valueType : ValueType

  # Parent class
  getter parentClass : StorageClass

  def initialize(id, @parentClass, @name, @valueType)
    super(id)
  end
end

# Class attribute
class StorageClassAttribute < StorageAttribute
  def initialize(parentClass, id, name, valueType)
    super(id, parentClass, name, valueType)
  end
end

# Instance attribute
class StorageInstanceAttribute < StorageAttribute
  def initialize(parentClass, id, name, valueType)
    super(id, parentClass, name, valueType)
  end
end

# Attribute with value
class StorageAttributeWithValue < StorageEntity
  # Attribute info
  getter attribute : StorageAttribute

  # Value to store
  property value : VortexValue?

  def initialize(@attribute, @value)
    super(0_i64)
  end
end
