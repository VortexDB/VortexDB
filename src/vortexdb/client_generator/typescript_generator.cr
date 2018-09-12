# Generator for typescript code
class TypescriptClientGenerator < ClientGenerator
  register("typescript")

  # Generate class for client
  private def generateClass(cls : StorageClass) : String
    attrArr = String.build do |str|      
    end

    return dataSrt = %(
        class #{cls.name}Class            
        end
    )
  end

  # Generate instance for client
  private def generateInstance(cls : StorageClass) : String
    ""
  end

  # Generate code
  def generate(storage : Storage, fileName : String) : Void
    genStr = String.build do |str|
      storage.iterateClasses do |cls|
        clsData = generateClass(cls)
        str << clsData
        instData = generateInstance(cls)
        str << instData
      end
    end

    File.write(fileName, genStr)
  end
end
