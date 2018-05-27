require "./database/database"
require "./data_logger/data_logger"
require "./data_logger/data_log_dumper"
require "./storage/storage"
require "./command_processor"
require "./console_server"

# Порт для обработки команда
COMMAND_PORT = 26301

database = Database.new
logReader = DataLogReader.new
logDumper = DataLogDumper.new(database, logReader)

logDumper.dump

dataLogWriter = DataLogWriter.new

storage = Storage.new(dataLogWriter)
commandProcessor = CommandProcessor.new(storage)
consoleServer = ConsoleServer.new(COMMAND_PORT, commandProcessor)
consoleServer.start