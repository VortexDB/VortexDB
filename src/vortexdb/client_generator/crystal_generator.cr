# Generator for crystal code
class CrystalClientGenerator < ClientGenerator
  GENERATED_FILE_NAME = "generated.cr"

  # Generate class for client
  private def generateClass(cls : StorageClass) : String
    attrArr = String.build do |str|
      clsName = "#{cls.name}Class"

      str << %(CLASS_NAME = "#{clsName}"\n)

      cls.iterateClassAttribute do |attr|
        str << "@#{attr.name} : #{attr.valueType}?\n"
        str << %(
                    def #{attr.name} : #{attr.valueType}
                        @client.getClassAttributeValue(CLASS_NAME, @#{attr.name})
                    end

                    def #{attr.name}=(value : #{attr.valueType}) : Void
                        @client.setClassAttributeValue(CLASS_NAME, @#{attr.name}, value)
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
          @client.iterateInstances(#{cls.name}Class)
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

      str << %(CLASS_NAME = "#{clsName}"\n)
      str << %(
        getter parent : #{clsName}
      )

      cls.iterateInstanceAttribute do |attr|
        str << "@#{attr.name} : #{attr.valueType}?\n"
        str << %(
                  def #{attr.name} : #{attr.valueType}
                      @client.getInstanceAttributeValue(CLASS_NAME, @#{attr.name})
                  end

                  def #{attr.name}=(value : #{attr.valueType}) : Void
                      @client.setInstanceAttributeValue(CLASS_NAME, @#{attr.name}, value)
                  end
              )
      end

      str << %(
          def initialize(client : CommonClient)
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

  # Generate vortex client
  def generateVortexClient(storage : Storage) : String
    attrStr = String.build do |str|
      str << %(
        getter host : String
        getter port : Int32
        getter commonClient : CommonClient

        def initialize(@host : String, @port : Int32)          
        end

        def open : Void
        end

        def get(entityType) : ClientEntity
          if entityType <= ClientEntity
            return entityType.new(@commonClient)
          end
          raise Exception.new("Wrong type")
        end
      )      
    end

    dataStr = %(
        class VortexClient
          #{attrStr}
        end
      )

    return dataStr
  end

  # Generate code
  def generate(storage : Storage) : Void
    genStr = String.build do |str|
      str << %(require "common_client")

      storage.iterateClasses do |cls|
        clsData = generateClass(cls)
        str << clsData
        instData = generateInstance(cls)
        str << instData
      end

      clientStr = generateVortexClient(storage)
      str << clientStr
    end

    File.write(GENERATED_FILE_NAME, genStr)
    Process.new("crystal", ["tool", "format", GENERATED_FILE_NAME])
  end
end
