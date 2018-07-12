# Console server client
class CommandClient
    # Client socket
    getter socket : Socket
    
    def initialize(@socket)
    end
  
    # Send line
    def sendLine(message)
      begin
        @socket.send("#{message}\n")
      rescue
        puts "Send error"
      end
    end
  end