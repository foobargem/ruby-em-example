require "rubygems"
require "eventmachine"
require "em-websocket"

EventMachine.run do
	@channel = EM::Channel.new

	EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|

		ws.onopen {
			sid = @channel.subscribe{ |msg| ws.send msg }

			ws.onmessage { |msg|
				@channel.push "<#{sid}>: #{msg}"
			}

			ws.onclose {
				@channel.unsubscribe(sid)
			}
		}

	end

	puts "Server started..\n"
end
