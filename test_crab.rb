# Require the library
require 'rubyserial'
class Crab
# Instantiate serial
def initialize
#@@my_serial = Serial.new("/dev/ttyACM0", baude_rate = 115200, data_bits = 8)

end
# Get data and do whatever you want with it
def lookie
size = 1024
data = @@my_serial.read(size)
end

# Set leg and positions for manual moving of the leg(s).
#def move(leg_num, pos_1, pos_2, pos_3)
# data = ""
#data = "Leg(#{leg_num},#{pos_1},#{pos_2},#{pos_3})"
#@@my_serial.write(data)
#end

def move(position)

legs = [0,1,2,3,4,5]

case position

when "reset"
  my_serial = Serial.new("/dev/ttyACM0", 115200)
  legs.each do |num|
  leg = "Leg(#{num},150,150,150)"
  puts leg
  my_serial.write(leg)
  end
  my_serial.close

when "standup"
j1 = 150
j2 = 150
my_serial = Serial.new("/dev/ttyACM0", 115200)
for u in 0..5
j1 = j1 + 6
j2 = j2 + 1.5
legs.each do |num|
leg = "Leg(#{num},150,#{j1},#{j2})"
puts leg
my_serial.write(leg)
end
sleep 0.075
end
my_serial.close

when "laydown"
p1 = 5
p2 = 3
my_serial = Serial.new("/dev/ttyACM0", 115200)
for p in 0..10
p1 = p1 - 5
legs.each do |num|
leg = "Leg(#{num},150,#{p1},#{p1})"
puts leg
my_serial.write(leg)
end
sleep 0.075
end
my_serial.close

when "updownX3"
for m in 0..2
move("standup")
sleep 0.075
move("laydown")
end


when "wave"

alt_legs = [0,2,4,5,3,1]
alt_legs.each do |num|
leg = "Leg(#{num},150,180,165)"
puts leg
@@my_serial.write(leg)
sleep 0.25
end
sleep 1

alt_legs = [1,3,5,4,2,0]
alt_legs.each do |num|
leg = "Leg(#{num},150,120,120)"
puts leg
@@my_serial.write(leg)
sleep 0.25

end

end

end



# method to make rc9k dance
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
data_reset = "Leg(#{leg_num},#{pos_1},#{pos_2},#{pos_3})"
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
crab = Crab.new
end
