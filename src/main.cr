require "./command_processor"
require "./console_server"

# Порт для обработки команда
COMMAND_PORT = 26301

commandProcessor = CommandProcessor.new
consoleServer = ConsoleServer.new(COMMAND_PORT, commandProcessor)
consoleServer.start