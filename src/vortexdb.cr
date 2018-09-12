require "./vortexdb/**"

# Port for processing commands
COMMAND_PORT = 26301
# Port for data processing
DATA_PORT = 26302

database = Database.new
logReader = DataLogReader.new
logDumper = DataLogDumper.new(database, logReader)
logDumper.dump

dataLogWriter = DataLogWriter.new
storage = Storage.new(database, dataLogWriter)
commandProcessor = CommandProcessor.new(storage)
consoleServer = ConsoleServer.new(COMMAND_PORT, commandProcessor)
erServer = ExternalRequestServer.new(DATA_PORT, commandProcessor)

spawn do
  puts "Start console server port: #{COMMAND_PORT}"
  consoleServer.start
end

spawn do
  puts "Start external request server port: #{DATA_PORT}"
  erServer.start
end

# Wait forever
loop do
  sleep 10
end
