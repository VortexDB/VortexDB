# Client vortex class
class CVClass
  # Class id
  getter id : Int64

  # Class name
  getter name : String

  # Parent class
  getter parent : CVClass?

  def initialize(@id, @name, @parent = nil)
  end
end

# Client vortex instance
class CVInstance
  # Instance id
  getter id : Int64

  # Parent class
  getter parent : CVClass

  def initialize(@id, @parent)
  end
end
