# Generator for crystal code
class CrystalClientGenerator < ClientGenerator
  GENERATED_FILE_NAME = "generated.cr"

  # Generate class for client
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

      str << %(
        def instances : Iterator(ClientInstance)
          @client.iterateInstances(#{cls.name}CC)
        end
      )
    end

    parStr = ""
    if parent = cls.parentClass
      parStr = " < #{cls.parentName}"
    else
      parStr = " < ClientClass"
    end    

    dataSrt = %(
        class #{cls.name}CC#{parStr}
            #{attrArr}
        end
        )

    return dataSrt
  end

  # Generate instance for client
  def generateInstance(cls : StorageClass) : String    
    attrArr = String.build do |str|
      cls.iterateInstanceAttribute do |attr|
        str << "@#{attr.name} : #{attr.valueType}?\n"
        str << %(
                  def #{attr.name} : #{attr.valueType}
                      @client.getInstanceAttributeValue(@name, #{attr.name})
                  end

                  def #{attr.name}=(value : #{attr.valueType}) : Void
                      @client.setInstanceAttributeValue(@name, #{attr.name}, value)
                  end
              )
      end

      str << %(
          def initialize(client : CommonClient)
            super(client)
          end
        )
    end
    
    parStr = "< ClientInstance"    

    dataSrt = %(
        class #{cls.name}CI#{parStr}
            #{attrArr}
        end
        )
        
    return dataSrt
  end

  # Generate code
  def generate(storage : Storage) : Void
    genStr = String.build do |str|
      storage.iterateClasses do |cls|
        clsData = generateClass(cls)
        str << clsData
        instData = generateInstance(cls)
        str << instData
      end
    end

    File.write(GENERATED_FILE_NAME, genStr)
    Process.new("crystal", ["tool", "format", GENERATED_FILE_NAME])
  end
end
