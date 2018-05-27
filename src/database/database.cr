require "db"
require "sqlite3"
require "./database_contracts"

# For read/write data to database
class Database
    # Database name
    DATABASE_NAME = "vortex.db"

    # Database
    @database : DB::Database

    # Open database
    private def openDatabase
        DB.open("sqlite3://./#{DATABASE_NAME}")
    end

    # Create and prepare database
    private def createDatabase
        base = openDatabase
        base.exec("CREATE TABLE t_classes(id integer PRIMARY KEY, name TEXT NOT NULL, parentId INTEGER)")
        base.exec("CREATE UNIQUE INDEX t_classes_idx ON t_classes(name)")
        base
    end

    # Opens or creates database
    private def openOrCreate : DB::Database        
        if File.exists?(DATABASE_NAME)
            return openDatabase
        else
            createDatabase
        end
    end

    def initialize        
        @database = openOrCreate
    end

    # Write to database
    def write(data : DatabaseContract) : Void
        case data
        when DBClass            
            @database.exec("INSERT INTO t_classes VALUES(?,?,?)", data.id, data.name, data.parentId || -1)
        else
            raise VortexException.new("Unknown database contract")
        end
    end
end