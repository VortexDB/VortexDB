require "./contracts"

# In-memory storage for entities
class Storage
    # In-memory storage 
    @storageClasses : Hash(String, StorageClass)
        
    def initialize
        @storageClasses = Hash(String, StorageClass).new
    end

    # Returns class by name
    def getClassByName(name : String) : StorageClass?
        return @storageClasses[name]?
    end

    # Creates class for storage and returns it
    def createClass(name : String, parent : StorageClass?) : StorageClass
        nclass = StorageClass.new(name, parent)
        @storageClasses[nclass.name] = nclass
        p nclass
        return nclass
    end

    # Create new instance
    def createInstance(name : String, parentClass : StorageClass) : StorageInstance
    end

    # Creates new class attribute
    def createClassAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageAttribute
    end

    # Creates new instance attribute
    def createInstanceAttribute(parent : StorageClass, name : String, valueType : ValueType) : StorageAttribute
    end
end