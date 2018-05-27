require "./data_logger"
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
        @logReader.readByLine do |line|
            case line
            when NewClassLog
                @database.write(DBClass.new(
                    id: line.id,
                    name: line.name,
                    parentId: line.parentId
                ))
            else
                
            end
        end
    end
end