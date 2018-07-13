# Geneartes client code
abstract class ClientGenerator
  macro register(target)
    ClientGeneratorFactory.knownGenerators[{{ target }}] = {{ @type }}.new
  end

  # Generate code
  abstract def generate(storage : Storage, fileName : String) : Void
end
