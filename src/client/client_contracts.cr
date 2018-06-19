require "./common_client"

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