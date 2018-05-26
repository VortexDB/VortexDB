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
    p dataLog
    @file.write_bytes(dataLog.contract.size.to_i32)
    @file << dataLog.contract
    @file.write_bytes(dataLog)
    @file.flush
  end
end

# Read log
class DataLogReader  
  def initialize    
  end

  # Read log by line
  def readByLine(&block : DataLog -> _)    
    return unless File.exists?(DataLogConsts::LOG_FILE_NAME)
    file = File.open(DataLogConsts::LOG_FILE_NAME)

    begin
      loop do
        nameSize = file.read_bytes(Int32)
        name = file.read_string(nameSize)

        dataLog : DataLog?
        case name
        when NewClassLog::NAME
          dataLog = file.read_bytes(NewClassLog)
        else
        end

        if dataLog
          yield dataLog
        end
      end
    rescue e : IO::EOFError
      # Ignore
    end
  end
end
