class BaseCC < ClientClass
  @name : String?

  def name : String
    @client.getClassAttributeValue(@name, name)
  end

  def name=(value : String) : Void
    @client.setClassAttributeValue(@name, name, value)
  end

  def initialize(@client : CommonClient)
  end

  def instances : Iterator(ClientInstance)
    @client.iterateInstances(BaseCC)
  end
end

class BaseCI < ClientInstance
  def initialize(client : CommonClient)
    super(client)
  end
end

class MeterCC < Base
  def initialize(client : CommonClient)
    super(client)
  end

  def instances : Iterator(ClientInstance)
    @client.iterateInstances(MeterCC)
  end
end

class MeterCI < ClientInstance
  def initialize(client : CommonClient)
    super(client)
  end
end
