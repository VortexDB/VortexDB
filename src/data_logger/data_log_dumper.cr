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
            when NewClassAttributeLog
                @database.write(DBClassAttribute.new(
                    id: item.id,
                    name: item.name,
                    parentId: item.parentId,
                    valueType: item.valueType
                ))
            else
                raise VortexException.new("Unknown log type")
            end
        end

        File.delete(DataLogConsts::LOG_FILE_NAME)
    end
end