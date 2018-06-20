require "./common_client"

# Base client entity
abstract class ClientEntity  
end

# Client class
class ClientClass
  # Parent 
  getter parent : ClientClass?
end

# Client class
class ClientInstance
  # Parent 
  getter parent : ClientClass

  def initialize(@client : CommonClient, @parent)
  end
end