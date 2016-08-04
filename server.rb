require 'em-websocket'
require 'json'

#
# broadcast all ruby related tweets to all connected users!
#

EventMachine.run {
  @channel = EM::Channel.new
  # status = JSON.parse(status)
  # @channel.push "#{status}"

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3001, :debug => true) do |ws|

    ws.onopen {
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push "#{sid} connected!"

      ws.onmessage { |msg|
        @channel.push "<#{sid}>: #{msg}"
      }

      ws.onclose {
        @channel.unsubscribe(sid)
      }
    }

    ws.onmessage { |msg|
      @channel.push "msg: #{msg}"
    }


  end

  puts "Server started"
}
