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
        base.exec("CREATE TABLE t_classes(
            id integer PRIMARY KEY, 
            name TEXT NOT NULL, 
            parentId INTEGER)")
        base.exec("CREATE TABLE t_attributes(
            id integer PRIMARY KEY, 
            name TEXT NOT NULL, 
            parentId INTEGER, 
            valueType TEXT NOT NULL,
            isClass INTEGER)")

        base.exec("CREATE TABLE t_values(
            id integer PRIMARY KEY,
            value TEXT
        )
        ")

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
        when DBClassAttribute                      
            @database.exec("INSERT INTO t_attributes VALUES(?,?,?,?,1)", data.id, data.name, data.parentId, data.valueType)
        else
            raise VortexException.new("Unknown database contract")
        end
    end

    # Iterates classes
    def allClasses : Array(DBClass)
        @database.query_all("SELECT id, name, parentId FROM t_classes", as: DBClass)
    end
end