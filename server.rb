require 'socket'               # Get sockets from stdlib
# Server for testing and calibration
	def srvr
		Thread.new {
			server = TCPServer.open("0.0.0.0",2000)   # Socket to listen on port 2000
			loop {
			Thread.start(server.accept) do |client|
				while line = client.gets
				legaryz = line.chop.split(",")
				#legaryz = line.chop.split(",").map(&:to_i)
				puts line
				#test_leg(legaryz)
				testing(legaryz)
			end

		client.close
		end
			}
		}
	end
