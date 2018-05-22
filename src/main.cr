require "./storage/storage"
require "./command_processor"
require "./console_server"

# Порт для обработки команда
COMMAND_PORT = 26301

storage = Storage.new
commandProcessor = CommandProcessor.new(storage)
consoleServer = ConsoleServer.new(COMMAND_PORT, commandProcessor)
consoleServer.start