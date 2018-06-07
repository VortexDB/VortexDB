# Client vortex class
class CVClass
  # Class id
  getter id : Int64

  # Class name
  getter name : String

  # Parent class
  getter parentName : String?

  def initialize(@id, @name, @parentName)
  end
end

# Client vortex instance
class CVInstance
  # Instance id
  getter id : Int64

  # Parent class
  getter parentName : String

  def initialize(@id, @parentName)
  end
end
