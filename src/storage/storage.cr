require "./contracts"

# In-memory storage for entities
class Storage
    # Counter for class entities id
    @classCounter : Int64 = 0_i64

    # In-memory storage 
    @storageClasses : Hash(Int64, StorageClass)
        
    def initialize
        @storageClasses = Hash(Int64, StorageClass).new
    end

    # Returns class by id
    def getClassById(id : Int64) : StorageClass?
        return @storageClasses[id]?
    end

    # Creates class for storage and returns it
    def createClass(name : String, parent : StorageClass?) : StorageClass
        nclass = StorageClass.new(@classCounter , name, parent)
        @storageClasses[nclass.id] = nclass
        @classCounter += 1
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