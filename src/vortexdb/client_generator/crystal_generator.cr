# Generator for crystal code
class CrystalClientGenerator < ClientGenerator
  GENERATED_FILE_NAME = "generated.cr"

  # Generate class
  private def generateClass(cls : StorageClass) : String
    attrArr = String.build do |str|
      cls.iterateClassAttribute do |attr|
        str << "@#{attr.name} : #{attr.valueType}?\n"
        str << %(
                    def #{attr.name} : #{attr.valueType}
                        @client.getClassAttributeValue(@name, #{attr.name})
                    end

                    def #{attr.name}=(value : #{attr.valueType}) : Void
                        @client.setClassAttributeValue(@name, #{attr.name}, value)
                    end
                )
      end

      if cls.parentClass.nil?
        str << %(
          def initialize(@client : CommonClient)
          end
        )
      else
        str << %(
          def initialize(client : CommonClient)
            super(client)
          end
        )
      end
    end

    parStr = ""
    parStr = " < #{cls.parentName}" if cls.parentClass

    dataSrt = %(
        class #{cls.name}#{parStr}
            #{attrArr}
        end
        )

    return dataSrt
  end

  # Generate code
  def generate(storage : Storage) : Void
    genStr = String.build do |str|
      storage.iterateClasses do |cls|
        clsdata = generateClass(cls)
        str << clsdata
      end
    end

    File.write(GENERATED_FILE_NAME, genStr)
    Process.new("crystal", ["tool", "format", GENERATED_FILE_NAME])
  end
end
