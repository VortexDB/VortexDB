class WebAdminServer
    def initialize        
    end

    # Start server
    def start : Void
        #public_folder  "web"
        serve_static true

        get "/" do |env|
            send_file env, "./public/index.html", "text/html"
        end
    end
end