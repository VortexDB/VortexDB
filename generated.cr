class BaseClass < ClientClass
  CLASS_NAME = "BaseClass"
  @id : Int?

  def id : Int
    @client.getClassAttributeValue(CLASS_NAME, @id)
  end

  def id=(value : Int) : Void
    @client.setClassAttributeValue(CLASS_NAME, @id, value)
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
