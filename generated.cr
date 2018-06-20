require "common_client"

class BaseClass < ClientClass
  CLASS_NAME = "BaseClass"
  @name : String?

  def name : String
    @client.getClassAttributeValue(CLASS_NAME, @name)
  end

  def name=(value : String) : Void
    @client.setClassAttributeValue(CLASS_NAME, @name, value)
  end

  def initialize(@client : CommonClient)
  end

  def instances : Iterator(ClientInstance)
    @client.iterateInstances(BaseClass)
  end
end

class BaseInstance < ClientInstance
  CLASS_NAME = "BaseClass"

  getter parent : BaseClass

  def initialize(client : CommonClient)
    @parent = BaseClass.new(client)
    super(client)
  end
end

class MeterClass < Base
  CLASS_NAME = "MeterClass"

  def initialize(client : CommonClient)
    super(client)
  end

  def instances : Iterator(ClientInstance)
    @client.iterateInstances(MeterClass)
  end
end

class MeterInstance < ClientInstance
  CLASS_NAME = "MeterClass"

  getter parent : MeterClass
  @serial : String?

  def serial : String
    @client.getInstanceAttributeValue(CLASS_NAME, @serial)
  end

  def serial=(value : String) : Void
    @client.setInstanceAttributeValue(CLASS_NAME, @serial, value)
  end

  def initialize(client : CommonClient)
    @parent = MeterClass.new(client)
    super(client)
  end
end

class VortexClient
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
end
