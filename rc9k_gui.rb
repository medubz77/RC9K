require 'socket'               # Get sockets from stdlib

Shoes.app title: "Testing and calibration program: " do
  stack do
    para ""

    flow do
      para "Choose a Leg: "
      @@list = list_box width: 50, items: [0, 1, 2, 3, 4, 5], choose: 0
      para "Joint 1: "
      @@jnt1 = edit_line width: 50
      para "Joint 2: "
      @@jnt2 = edit_line width: 50
      para "Joint 3: "
      @@jnt3 = edit_line width: 50
    end
    para ""
  end
  stack do
    @button = button("Test") do
      hostname = '127.0.0.1'
      port = 2000
      Thread.new {
        s = TCPSocket.open(hostname, port)
        #s.puts "#{@@list.text.to_i}, #{@@jnt1.text.to_i}, #{@@jnt2.text.to_i}"
        s.puts "Leg,#{@@list.text.to_i},pos1,#{@@jnt1.text.to_i},pos2,#{@@jnt2.text.to_i},pos3,#{@@jnt3.text.to_i}"
        s.close
     }

    end
  end
end
