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
  def write(dataLog : LogContract) : Void
    p dataLog
    @file.write_bytes(dataLog)
    @file.flush
  end
end

# Read log
class DataLogReader  
  def initialize    
  end

  # Read log by line
  def readByLine(&block : LogContract -> _)    
    return unless File.exists?(DataLogConsts::LOG_FILE_NAME)
    file = File.open(DataLogConsts::LOG_FILE_NAME)

    begin
      loop do
        nameSize = file.read_bytes(Int32)
        name = file.read_string(nameSize)

        creator = LogContract.creators[name]?
        next if creator.nil?
        dataLog = creator.call(file, IO::ByteFormat::SystemEndian).as(LogContract)
        yield dataLog
      end
    rescue e : IO::EOFError
      # Ignore
    ensure
      file.close
    end
  end
end
