# Generator for crystal code
class CrystalClientGenerator < ClientGenerator
    # Generate class
    private def generateClass(cls : StorageClass) : Void
        parStr = ""
        parStr = " < #{cls.parentName}" if cls.parentClass

        dataSrt = %(\
        class #{cls.name}#{parStr} \

        end\
        )

        p dataSrt
    end

    # Generate code
    def generate(storage : Storage) : Void
        storage.iterateClasses do |cls|
            generateClass(cls)
        end
    end
end