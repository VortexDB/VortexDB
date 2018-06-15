require "../database/database"

# Dump data log to database
class DataLogDumper
  # For working
  @database : Database

  # Log reader
  @logReader : DataLogReader

  def initialize(@database, @logReader)
  end

  # Dump log to database
  def dump : Void
    return unless File.exists?(DataLogConsts::LOG_FILE_NAME)

    @logReader.readByLine do |item|
      case item
      when NewClassLog
        @database.write(DBClass.new(
          id: item.id,
          name: item.name,
          parentId: item.parentId
        ))
      when NewInstanceLog
        @database.write(DBInstance.new(
          id: item.id,
          parentId: item.parentId
        ))
      when NewAttributeLog
        @database.write(DBAttribute.new(
          id: item.id,
          name: item.name,
          parentId: item.parentId,
          valueType: item.valueType,
          isClass: item.isClass
        ))
      when SetAttributeValueLog
        @database.write(DBAttributeValue.new(
          attributeId: item.attributeId,
          value: item.value
        ))
      else
        raise VortexException.new("Unknown log type")
      end
    end

    File.delete(DataLogConsts::LOG_FILE_NAME)
  end
end
