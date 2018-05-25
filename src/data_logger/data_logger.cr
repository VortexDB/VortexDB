require "./data_logger_contracts"

# Constants for data log
class DataLogConsts
    # Log file
    LOG_FILE_NAME = "data.log"
end

# Logs actions to file
class DataLogWriter    
    # Log file
    @file : File

    def initialize
        @file = File.open(DataLogConsts::LOG_FILE_NAME, "a")        
    end

    # Write data to log
    def write(dataLog : DataLog) : Void
        data = dataLog.to_msgpack

        buffer = IO::Memory.new
        buffer << dataLog.contract.size
        buffer << dataLog.contract
        buffer << data.size
        buffer.write(data)
        
        @file.write(buffer.to_slice)
        @file.flush
    end
end

# Read log
class DataLogReader
    # Log file
    @file : File

    def initialize
        @file = File.open(DataLogConsts::LOG_FILE_NAME, "r")
    end

    # Read log by line
    def readByLine(&block : DataLog -> _)
    end
end