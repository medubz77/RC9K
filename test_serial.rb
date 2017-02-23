# Require the library
require 'rubyserial'
class TestSerial
# Instantiate serial
def initialize
@@my_serial = Serial.new("/dev/ttyACM1", baude_rate = 115200, data_bits = 8)
end
# Get data and do whatever you want with it
def lookie
size = 1024
data = @@my_serial.read(size)
end
# Set data
def move(leg_num, pos_1, pos_2, pos_3)
# data = ""
data = "Leg(#{leg_num},#{pos_1},#{pos_2},#{pos_3})"
@@my_serial.write(data)
end
def dance
# data = ""
counter = [0,1,2,3,4,5]
pos = [100,150,200]
counter.each do |c|
leg_num = c
pos_1 = pos.sample
pos_2 = pos.sample
pos_3 = pos.sample
data = "Leg(#{leg_num},#{pos_1},#{pos_2},#{pos_3})"
puts data
@@my_serial.write(data)
sleep 1
end
leg_num = nil
pos_1 = nil
pos_2 = nil
pos_3 = nil
counter.each do |r|
leg_num = r
pos_1 = 150
pos_2 = 150
pos_3 = 150
data_reset = "Leg(#{leg_num},#{pos_1},#{pos_2}#{pos_3})"
@@my_serial.write(data_reset)
puts data_reset
sleep 1
end
end
# Close serial once you're done using it
def stop_serial
@@my_serial.close
@@my_serial = nil
end
end
