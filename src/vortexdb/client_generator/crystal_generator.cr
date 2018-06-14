# Generator for crystal code
class CrystalClientGenerator < ClientGenerator
    # Generate class
    private def generateClass(cls : StorageClass) : Void
        attrArr = String.build do |str|
            cls.iterateClassAttribute do |attr|
                str << "@#{attr.name} : #{attr.valueType}\n"
                str << %(
                    def #{attr.name} : #{attr.valueType}
                        @client.getClassAttributeValue(@name, #{attr.name})\
                    end\

                    def #{attr.name}=(value : #{attr.valueType}) : Void
                        @client.setClassAttributeValue(@name, #{attr.name}, value)\
                    end\
                )
            end
        end

        parStr = ""
        parStr = " < #{cls.parentName}" if cls.parentClass

        dataSrt = %(\
        class #{cls.name}#{parStr} \
            #{attrArr}
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