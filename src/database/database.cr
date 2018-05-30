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
            attributeId integer,
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
        when DBAttributeValue
            row = @database.query_one?("SELECT attributeId FROM t_values WHERE attributeId=?", data.attributeId, as: {Int64})
            if row.nil?
                @database.exec("INSERT INTO t_values VALUES(?,?)", data.attributeId, data.value)
            else
                @database.exec("UPDATE t_values SET value=? WHERE attributeId=?", data.value, data.attributeId)
            end            
        else
            raise VortexException.new("Unknown database contract")
        end
    end

    # Return all classes
    def allClasses : Array(DBClass)
        @database.query_all("SELECT id, name, parentId FROM t_classes", as: DBClass)
    end

    # Return all attributes
    def allAttributes(&block : DBAttribute -> _) : Void
        @database.query("SELECT id, name, parentId, valueType, isClass FROM t_attributes") do |rs|
            rs.each do
                id = rs.read(Int64)
                name = rs.read(String)
                parentId = rs.read(Int64)
                valueType = rs.read(String)
                isClass = rs.read(Int32)
                if isClass > 0
                    yield DBClassAttribute.new(
                        id: id,
                        name: name,
                        parentId: parentId,
                        valueType: valueType
                    )
                else
                    yield DBInstanceAttribute.new(
                        id: id,
                        name: name,
                        parentId: parentId,
                        valueType: valueType
                    )
                end
            end
        end
    end

    # Return all values
    def allValues(&block : DBAttributeValue -> _)
        @database.query("SELECT attributeId, value FROM t_values") do |rs|
            rs.each do
                yield DBAttributeValue.new(
                    attributeId: rs.read(Int64),
                    value: rs.read(String)
                )
            end
        end
    end
end