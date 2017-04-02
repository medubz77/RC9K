# Require the library
require 'rubyserial'
class Crab
# Instantiate serial
def initialize
#@@my_serial = Serial.new("/dev/ttyACM0", baude_rate = 115200, data_bits = 8)
@@j1 = 150
@@j2 = 140
@@j3 = 144
$legs =[150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144]
$tomove=[150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144]
$periter=[150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144,150, 140, 144]
$test1=[100, 100, 100,100, 100, 100,100, 100, 100,100, 100, 100,100, 100, 100,100, 100, 100]
$test2=[200, 200, 200,200, 200, 200,200, 200,200,200, 200, 200,200, 200, 200,200, 200, 200]
end
# Get data and do whatever you want with it
def lookie

end

def writetolegs(pos, steps, time)
 # my_serial = Serial.new("/dev/ttyACM0", 115200)
 inarray=0
 $legs.each do
	$tomove[inarray]=pos[inarray]-$legs[inarray]
	inarray+=1
end 
inarray=0
 $tomove.each do
 $periter[inarray]=$tomove[inarray]/steps
 inarray +=1
 end

while steps>0
sleep time
steps=steps-1
inarray=0
 $legs.each do
	$legs[inarray]+=$periter[inarray]
	inarray+=1
end 
# my_serial.write("Leg(0,$legs[0],$legs[1],$legs[2])")
# my_serial.write("Leg(1,$legs[3],$legs[4],$legs[5])")
# my_serial.write("Leg(2,$legs[6],$legs[7],$legs[8])")
# my_serial.write("Leg(3,$legs[9],$legs[10],$legs[11])")
# my_serial.write("Leg(4,$legs[12],$legs[13],$legs[14])")
# my_serial.write("Leg(5,$legs[15],$legs[16],$legs[17])")


puts "Leg(0,#{$legs[0]},#{$legs[1]},#{$legs[2]})"
puts "Leg(1,#{$legs[3]},#{$legs[4]},#{$legs[5]})"
puts "Leg(2,#{$legs[6]},#{$legs[7]},#{$legs[8]})"
puts "Leg(3,#{$legs[9]},#{$legs[10]},#{$legs[11]})"
puts "Leg(4,#{$legs[12]},#{$legs[13]},#{$legs[14]})"
puts "Leg(5,#{$legs[15]},#{$legs[16]},#{$legs[17]})"

puts steps
end
#my_serial.close

end

def move(position)

case position

when "reset"
  legs = [0,1,2,3,4,5]
  my_serial = Serial.new("/dev/ttyACM0", 115200)
  legs.each do |num|
  leg = "Leg(#{num},150,140,144)"
  puts leg
  my_serial.write(leg)
  sleep 0.2
  end
  puts "Reset Position"
  @@j1 = 150
  @@j2 = 140
  @@j3 = 144
  my_serial.close

when "standup"
standpos =[150,170,169,150,170,169,150,170,169,150,170,169,150,170,169,150,170,169]
writetolegs(standpos, 5, 0.3)
# legs = [0,1,2,3,4,5]
# @@j2 = 140
# @@j3 = 144
# my_serial = Serial.new("/dev/ttyACM0", 115200)
# i=0
# while i < 5
# @@j2+=6
# @@j3+=5
# legs.each do |num|
# leg = "Leg(#{num},#{@@j1},#{@@j2},#{@@j3})"
# puts "#{i}"
# puts leg
# my_serial.write(leg)
# sleep 0.01
# end
# i+=1
# end
puts "I'm Standing!"
#my_serial.close

when "laydown"
standpos =[150,140,144,150,140,144,150,140,144,150,140,144,150,140,144,150,140,144]
writetolegs(standpos, 5, 0.3)
#my_serial = Serial.new("/dev/ttyACM0", 115200)
#puts "already laying down"
#legs = [0,1,2,3,4,5]
#i=0
#while i < 5
#@@j2 = @@j2 - 6
#@@j3 = @@j3 - 5
#legs.each do |num|
#leg = "Leg(#{num},#{@@j1},#{@@j2},#{@@j3})"
#puts leg
#my_serial.write(leg)
#sleep 0.05
#end
#i+=1
#end
puts "Laying Down"
#my_serial.close

when "updownX5"
for m in 0..4
move("standup")
sleep 0.15
move("laydown")
end

when "frontstand"
move("reset")
sleep 0.05
my_serial = Serial.new("/dev/ttyACM0", 115200)
legs = [2,3,4,5]
i=0
while i < 8
@@j2+=4
@@j3+=3
legs.each do |num|
leg = "Leg(#{num},#{@@j1},#{@@j2},#{@@j3})"
my_serial.write(leg)
puts leg
sleep 0.015
end
i+=1
end
my_serial.close




when "wave"
move("frontstand")
sleep 0.1
my_serial = Serial.new("/dev/ttyACM0", 115200)
i=0
leg_num = 5
@@j2 = 109
while i < 4
@@j3 = @@j3 - 35
leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
my_serial.write(leg)
puts leg
puts "wave up"
sleep 0.25
@@j3 = @@j3+=35
leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
my_serial.write(leg)
puts leg
puts "wave down"
i+=1
sleep 0.25

end
sleep 1
@@j1 = 150
@@j2 = 170
@@j3 = 169
leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
my_serial.write(leg)

move("laydown")
move("reset")
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
#def stop_serial
#@@my_serial.close
#@@my_serial = nil
#end
#crab = Crab.new
#crab.move("standup")
end
