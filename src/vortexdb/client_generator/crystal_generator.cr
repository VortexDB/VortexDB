# Generator for crystal code
class CrystalClientGenerator < ClientGenerator
  GENERATED_FILE_NAME = "generated.cr"

  # Generate class for client
  private def generateClass(cls : StorageClass) : String
    attrArr = String.build do |str|
      instName = "#{cls.name}Instance"

      str << %(CLASS_NAME = "#{cls.name}"\n)
      str << %(
        def className : String
          CLASS_NAME
        end
      )

      cls.iterateClassAttribute do |attr|
        str << "@#{attr.name} : #{attr.valueType}?\n"
        str << %(
                    def #{attr.name} : #{attr.valueType}
                        @client.getClassAttributeValue(self, "#{attr.name}", ValueType::#{attr.valueType})
                    end

                    def #{attr.name}=(value : #{attr.valueType}) : Void
                        @client.setClassAttributeValue(self, "#{attr.name}", value)
                    end
                )
      end

      parentClass = cls.parentClass

      if parentClass
        parentName = "#{parentClass.name}Class"
        str << %(
          getter parent#{parentClass.name} : #{parentName}
        )

        str << %(
          def initialize(client : VortexClient)
            @parent#{parentClass.name} = #{parentName}.new(client)
            super(client)
          end
        )
      else
        str << %(
          def initialize(@client : VortexClient)
          end
        )
      end
      
      str << %(
        def instances(&block : #{instName} -> Void) : Void
          @client.iterateInstances(self, #{cls.name}, &block)
        end
      )
    end

    parStr = ""
    if parent = cls.parentClass
      parStr = " < #{cls.parentName}Class"
    else
      parStr = " < ClientClass"
    end

    dataSrt = %(
        class #{cls.name}Class#{parStr}
            #{attrArr}
        end
        )

    return dataSrt
  end

  # Generate instance for client
  def generateInstance(cls : StorageClass) : String
    attrArr = String.build do |str|
      clsName = "#{cls.name}Class"

      str << "@id : Int64\n"

      str << %(CLASS_NAME = "#{cls.name}"\n)
      str << %(
        getter parent : #{clsName}
      )

      cls.iterateInstanceAttribute do |attr|
        str << "@#{attr.name} : #{attr.valueType}?\n"
        str << %(
                  def #{attr.name} : #{attr.valueType}
                      @client.getInstanceAttributeValue(parent, "#{attr.name}")
                  end

                  def #{attr.name}=(value : #{attr.valueType}) : Void
                      @client.setInstanceAttributeValue(parent, "#{attr.name}", value)
                  end
              )
      end

      str << %(
          def initialize(@id : Int64, client : VortexClient)
            @parent = #{clsName}.new(client)
            super(client)
          end
        )
    end

    parStr = "< ClientInstance"

    dataSrt = %(
        class #{cls.name}Instance#{parStr}
            #{attrArr}
        end
        )

    return dataSrt
  end

  # Generate code
  def generate(storage : Storage) : Void
    genStr = String.build do |str|
      str << %(require "commonclient")

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
