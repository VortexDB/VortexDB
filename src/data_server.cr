require "kemal"

# Main server for processing requests
# Uses websockets for transport
class DataServer
  # Path for websocket
  WS_PATH = "/kingdom"

  # Server port
  getter port : Int32

  # Command processor
  getter commandProcessor : CommandProcessor

  def initialize(@port, @commandProcessor)
  end

  # Start server
  def start : Void
    ws "/kingdom" do |socket|
      socket.send "Hello from Kemal!"
    end
    Kemal.run port
  end
end
