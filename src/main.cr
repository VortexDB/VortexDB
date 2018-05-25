require "./data_logger/data_logger"
require "./storage/storage"
require "./command_processor"
require "./console_server"

# Порт для обработки команда
COMMAND_PORT = 26301

dataLogger = DataLogWriter.new

storage = Storage.new(dataLogger)
commandProcessor = CommandProcessor.new(storage)
consoleServer = ConsoleServer.new(COMMAND_PORT, commandProcessor)
consoleServer.start