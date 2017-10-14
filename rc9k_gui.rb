require 'socket'               # Get sockets from stdlib

Shoes.app title: "Testing and calibration program: " do
  stack do
    para ""
#    flow do
#      para "Specify hostname here:"
#      $host = edit_line width: 200, text: "192.168.10.112"
#    end

    flow do
      para "Choose a Leg: "
      @@list = list_box width: 50, items: [0, 1, 2, 3, 4, 5], choose: 0
      para "Joint 1: "
      @@jnt1 = edit_line width: 50, text: "150"
      para "Joint 2: "
      @@jnt2 = edit_line width: 50, text: "140"
      para "Joint 3: "
      @@jnt3 = edit_line width: 50, text: "144"
    end
    para ""
    @pdata = para "Idle"
    @p = para "Status => "
  end
  stack do

    @button = button("Test") do
      hostname = '192.168.15.35'
      port = 2001
      @p.text = "Initiating connection... "
      Thread.new {
        server = TCPSocket.open(hostname, port)
        send_data = "Leg,#{@@list.text.to_i},pos1,#{@@jnt1.text.to_i},pos2,#{@@jnt2.text.to_i},pos3,#{@@jnt3.text.to_i}"
        server.puts send_data
        @pdata.text = "Data sent: #{send_data}"
        while line = server.gets
          @p.text = "Data Received #{line}"
        end
        server.close
     }
    end
    para ""
    flow do
		@reset_button = button("Reset") do
			hostname = '127.0.0.1'
			port = 2001
			@p.text = "Initiating connection... "
			Thread.new {
				server = TCPSocket.open(hostname, port)
				send_data = "reset, COMMAND"
				server.puts send_data
				@pdata.text = "Data sent: #{send_data}"
			while line = server.gets
				@p.text = "Data Received #{line}"
			end
			server.close
		}
		end
		@stand_button = button("Stand") do
			hostname = '192.168.15.35'
			port = 2001
			@p.text = "Initiating connection... "
			Thread.new {
				server = TCPSocket.open(hostname, port)
				send_data = "stand, COMMAND"
				server.puts send_data
				@pdata.text = "Data sent: #{send_data}"
			while line = server.gets
				@p.text = "Data Received #{line}"
			end
			server.close
		}
		end
		@laydown_button = button("laydown") do
			hostname = '192.168.15.35'
			port = 2001
			@p.text = "Initiating connection... "
			Thread.new {
				server = TCPSocket.open(hostname, port)
				send_data = "laydown, COMMAND"
				server.puts send_data
				@pdata.text = "Data sent: #{send_data}"
			while line = server.gets
				@p.text = "Data Received #{line}"
			end
			server.close
		}
		end
	end
  end
end
