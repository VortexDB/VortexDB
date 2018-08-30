require "kemal"
require "./vortexdb/**"

# Port for processing commands
COMMAND_PORT = 26301
# Port for http server
HTTP_SERVER_PORT = 26302

database = Database.new
logReader = DataLogReader.new
logDumper = DataLogDumper.new(database, logReader)
logDumper.dump

dataLogWriter = DataLogWriter.new
storage = Storage.new(database, dataLogWriter)
commandProcessor = CommandProcessor.new(storage)
consoleServer = ConsoleServer.new(COMMAND_PORT, commandProcessor)
erServer = ExternalRequestServer.new(commandProcessor)
webadmin = WebAdminServer.new

# Start console server
spawn do
  consoleServer.start
end

# Start external request server
spawn do
  erServer.start
end

# Start web admin server
spawn do
  webadmin.start
end

# TODO: refactor
Kemal.run HTTP_SERVER_PORT

# Wait forever
loop do
  sleep 10
end
