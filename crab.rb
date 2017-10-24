# Require the library
require 'rubyserial'
# Require CSV for CSV functionality
#require 'csv'
#require 'socket' # Get sockets from stdlib
#require_relative './server.rb'
require './motor_control.rb'
class Crab
# Instantiate global variables
def initialize
# Joint position constants
	$j1l=135 # was 120
	$j1m=150
	$j1r=165 # was 180
	$j2u=150
	$j2d=120
	$j3u=140
	$j3d=227 # was 227
	$legs=[150,150,140,150,150,140,150,150,140,150,150,140,150,150,140,150,150,140]
	$tomove=[150,150,140,150,150,140,150,150,140,150,150,140,150,150,140,150,150,140]
	$periter=[150,150,140,150,150,140,150,150,140,150,150,140,150,150,140,150,150,140]
	#mc=MotorPower.new
	#mc.check_switch

#def watcher
#		mc.check_switch

#end



def start_video
# $v_pid = spawn '/home/pi/rc9k/vlc_stream.sh'
	$v_pid = fork do
		cmd = 'raspivid -o - -t 0 -w 640 -h 360 -fps 25|cvlc -vvv stream:///dev/stdin --sout \'#rtp{sdp=rtsp://:8554/}\' :demux=h264'
		exec cmd
	end # end do

end # end method

def die_video_die
	#Process.kill('INT', $v_pid)
	Process.kill(9 ,$v_pid)
end # end method

def test_legs(pos1, pos2, pos3)
	my_serial = Serial.new("/dev/ttyACM0", 115200) # RPI Serial
	legs = [0,1,2,3,4,5]
	legs.each do |leg|
		move_leg = "Leg(#{leg},#{pos1},#{pos2},#{pos3})"
		my_serial.write(move_leg)
		puts "#{move_leg}"
		sleep 0.05
	end
	my_serial.close
	my_serial = nil
end


def test_leg(leg, pos1, pos2, pos3)
	puts "pre-serial"
	my_serial = Serial.new("/dev/ttyACM0", 115200) # RPI Serial
	#my_serial = Serial.new("COM1", 115200)
	move_leg = "Leg(#{leg},#{pos1},#{pos2},#{pos3})"
	my_serial.write(move_leg)
	puts "#{move_leg}"
	##sleep 0.05
	##end
	my_serial.close
	my_serial = nil
	puts "post-serial"
end


def writetolegs(pos, steps, time)
  #legs_pos = calibrate
	my_serial = Serial.new("/dev/ttyACM0", 115200)
	#my_serial = Serial.new("COM1", 115200)
	inarray=0
	$legs.each do
		$tomove[inarray]=pos[inarray]-$legs[inarray]
		inarray+=1
	end
	inarray=0
	$tomove.each do
		$periter[inarray]=$tomove[inarray]/(steps+1)
		inarray +=1
	end
	while steps>=0
     sleep time
     steps=steps-1
     inarray=0
     $legs.each do
       $legs[inarray]+=$periter[inarray]
       inarray+=1
     end
		my_serial.write("Leg(0,#{$legs[0]},#{$legs[1]},#{$legs[2]})")

		my_serial.write("Leg(1,#{$legs[3]},#{$legs[4]},#{$legs[5]})")

		my_serial.write("Leg(2,#{$legs[6]},#{$legs[7]},#{$legs[8]})")

		#my_serial.write("Leg(3,#{$legs[9]},#{((($legs[10]-150)*1.10)+150).to_i},#{$legs[11]})")
my_serial.write("Leg(3,#{$legs[9]},#{$legs[10]},#{$legs[11]})")
#puts $legs[11]

		my_serial.write("Leg(4,#{$legs[12]},#{$legs[13]},#{$legs[14]})")

		my_serial.write("Leg(5,#{$legs[15]},#{$legs[16]},#{$legs[17]})")

		sleep 0.025
		#puts steps
	end
	my_serial.close
	my_serial = nil
end

def complex_walk(steps, speed, leftgait, rightgait ,left, right)  ##  steps, how many steps,  speed, delay in walking movements,  gaitleft how big of steps,
gaitrleft=$j1m+leftgait         #take mid position and add specified gait amount, movement to the right, left legs
gaitrcentr=$j1m+(rightgait*right)   #same as gaitr but apply right magnitude influence to center leg variable.  Note, we need 4 center leg vars, 2 per leg...
gaitlleft=$j1m-leftgait

gaitrright=$j1m+rightgait
gaitlright=$j1m-rightgait
gaitlcentr=$j1m-(rightgait*right)   ##gait move right center leg right side
gaitrcentl=$j1m+(leftgait*left)		# variables are what, what direction, what side
gaitlcentl=$j1m-(leftgait*left)
gaitrleft=gaitrleft.to_i
gaitrright=gaitrright.to_i
gaitlright=gaitlright.to_i               #recast as ints, could be that floats cause legs to wig out hard
gaitrcentl=gaitrcentl.to_i
gaitlleft=gaitlleft.to_i
gaitlcentl=gaitlcentl.to_i
gaitrcentr=gaitrcentr.to_i
gaitlcentr=gaitlcentr.to_i

#puts "centl"
#puts gaitrcentl
#puts gaitlcentl

#puts "centr"
#puts gaitrcentr
#puts gaitlcentr

																							##left and right, 1 1 for full speed forward, -1 for full speed back,  1 -1 for turn right
	while steps > 0
		steps = steps - 1
		##left Legs Up
		lg0 = [gaitrleft,$j2d-20,$j3d-20]      #r  $j1m +- 15 for movment.  Now will be $j1m + - gait * left (or right)
		lg3 = [gaitlcentl,$j2d-20,$j3d-20]			#l
		lg4 = [gaitrleft,$j2d-20,$j3d-20]			#r$jlm+15
		##right Legs Down
		lg1 = [gaitrright,$j2d+10,$j3d]					#r
		lg2 = [gaitlcentr,$j2d+10,$j3d]					#l
		lg5 = [gaitrright,$j2d+10,$j3d]					#r
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
		##all legs down
		lg0 = [gaitrleft,$j2d+10,$j3d]				#r
		lg3 = [gaitlcentl,$j2d+10,$j3d]				#l
		lg4 = [gaitrleft,$j2d+10,$j3d]				#r
		lg1 = [gaitrright,$j2d+10,$j3d]				#r
		lg2 = [gaitlcentr,$j2d+10,$j3d]				#l
		lg5 = [gaitrright,$j2d+10,$j3d]				#r
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
		##left  Legs Down
		lg0 = [gaitrleft,$j2d+10,$j3d]			#r
		lg3 = [gaitlcentl,$j2d+10,$j3d]			#l
		lg4 = [gaitrleft,$j2d+10,$j3d]			#r
		##right	Legs Up
		lg1 = [gaitrright,$j2d-20,$j3d-20]	#r
		lg2 = [gaitlcentr,$j2d-20,$j3d-20]	#l
		lg5 = [gaitrright,$j2d-20,$j3d-20]	#r
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
		##left Rotate Hips
		lg0 = [gaitlleft,$j2d+10,$j3d]  #l
		lg3 = [gaitrcentl,$j2d+10,$j3d]		#r
		lg4 = [gaitlleft,$j2d+10,$j3d]		#l
		##right Legs Up
		lg1 = [gaitlright,$j2d-20,$j3d-20]		#l
		lg2 = [gaitrcentr,$j2d-20,$j3d-20]		#r
		lg5 = [gaitlright,$j2d-20,$j3d-20]		#l
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
		##all legs down
		lg0 = [gaitlleft,$j2d+10,$j3d]		#l
		lg3 = [gaitrcentl,$j2d+10,$j3d]		#r
		lg4 = [gaitlleft,$j2d+10,$j3d]		#l
		lg1 = [gaitlright,$j2d+10,$j3d]		#l
		lg2 = [gaitrcentr,$j2d+10,$j3d]		#r
		lg5 = [gaitlright,$j2d+10,$j3d]		#l
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
		##left Legs Up
		lg0 = [gaitlleft,$j2d-20,$j3d-20]		#l
		lg3 = [gaitrcentl,$j2d-20,$j3d-20]		#r
		lg4 = [gaitlleft,$j2d-20,$j3d-20]		#l
		##right Legs Down
		lg1 = [gaitlright,$j2d+10,$j3d]				#l
		lg2 = [gaitrcentr,$j2d+10,$j3d]				#r
		lg5 = [gaitlright,$j2d+10,$j3d]				#l
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	end
	stand

end

def walk_cycle(steps, speed)
	while steps > 0
		steps = steps - 1
	##left Legs Up
		lg0 = [$j1r,$j2d-20,$j3d-20]
		lg3 = [$j1l,$j2d-20,$j3d-20]
		lg4 = [$j1r,$j2d-20,$j3d-20]
	##right Legs Down
		lg1 = [$j1r,$j2d+10,$j3d]
		lg2 = [$j1l,$j2d+10,$j3d]
		lg5 = [$j1r,$j2d+10,$j3d]
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	##all legs down
		lg0 = [$j1r,$j2d+10,$j3d]
		lg3 = [$j1l,$j2d+10,$j3d]
		lg4 = [$j1r,$j2d+10,$j3d]
		lg1 = [$j1r,$j2d+10,$j3d]
		lg2 = [$j1l,$j2d+10,$j3d]
		lg5 = [$j1r,$j2d+10,$j3d]
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	##left  Legs Down
		lg0 = [$j1r,$j2d+10,$j3d]
		lg3 = [$j1l,$j2d+10,$j3d]
		lg4 = [$j1r,$j2d+10,$j3d]
	##right	Legs Up
		lg1 = [$j1r,$j2d-20,$j3d-20]
		lg2 = [$j1l,$j2d-20,$j3d-20]
		lg5 = [$j1r,$j2d-20,$j3d-20]
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	##left Rotate Hips
		lg0 = [$j1l,$j2d+10,$j3d]
		lg3 = [$j1r,$j2d+10,$j3d]
		lg4 = [$j1l,$j2d+10,$j3d]
	##right Legs Up
		lg1 = [$j1l,$j2d-20,$j3d-20]
		lg2 = [$j1r,$j2d-20,$j3d-20]
		lg5 = [$j1l,$j2d-20,$j3d-20]
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	##all legs down
		lg0 = [$j1l,$j2d+10,$j3d]
		lg3 = [$j1r,$j2d+10,$j3d]
		lg4 = [$j1l,$j2d+10,$j3d]
		lg1 = [$j1l,$j2d+10,$j3d]
		lg2 = [$j1r,$j2d+10,$j3d]
		lg5 = [$j1l,$j2d+10,$j3d]
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	##left Legs Up
		lg0 = [$j1l,$j2d-20,$j3d-20]
		lg3 = [$j1r,$j2d-20,$j3d-20]
		lg4 = [$j1l,$j2d-20,$j3d-20]
	##right Legs Down
		lg1 = [$j1l,$j2d+10,$j3d]
		lg2 = [$j1r,$j2d+10,$j3d]
		lg5 = [$j1l,$j2d+10,$j3d]
		writetolegs(lg0 + lg1 + lg2 + lg3 + lg4 + lg5, 1, 0)
		sleep speed
	end
	stand
end

def walk(speed, gait)

end

def reset
	my_serial = Serial.new("/dev/ttyACM0", 115200)
	#my_serial = Serial.new("COM1", 115200)
	legs = [0,1,2,3,4,5]
	legs.each do |num|
		leg = "Leg(#{num},150,150,145)"
		puts leg
		my_serial.write("#{leg}")
		sleep 0.05
	end
	puts "Reset Position"
	my_serial.write("Position Reset.\r\n")
	my_serial.close
	my_serial = nil
end

def stand
	stand_pos = [$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d]
	writetolegs(stand_pos, 1, 0)
	puts "I'm Standing!"
	puts "#{stand_pos}"
end

def laydown
	laydown_pos = [$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u]
	writetolegs(laydown_pos, 10, 0.065)
	puts "Laying Down"
	puts "#{laydown_pos}"
end

def attack
	stand
	sleep 0.25
	box = ["B","B","B","B"]
	attack_pos = [$j1m,$j2u-10,$j3u,$j1m,$j2u-10,$j3u,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1r,$j2u-20,$j3u-20,$j1l,$j2u-20,$j3u-20]
	writetolegs(attack_pos,1, 0)
	puts "Attacking Pose"
	box_right = [$j1m,$j2u-10,$j3u,$j1m,$j2u-10,$j3u,$j1m,$j2d+20,$j3d,$j1m,$j2d+20,$j3d,$j1r,$j2u-30,$j3u-30,$j1l,$j2u+20,$j3u+20]
	box_left = [$j1m,$j2u-10,$j3u,$j1m,$j2u-10,$j3u,$j1m,$j2d+20,$j3d,$j1m,$j2d+20,$j3d,$j1r,$j2u+20,$j3u+20,$j1l,$j2u-30,$j3u-30]
	box.each do |c|
		writetolegs(box_right,10,0)
		sleep 0.025
		writetolegs(box_left,10,0)
		sleep 0.025
	end
	stand
end

def switch
	for m in 0..4
		movement = [$j1r,$j2d,$j3d,$j1l,$j2d,$j3d,$j1r,$j2d,$j3d,$j1l,$j2d,$j3d,$j1r,$j2d,$j3d,$j1l,$j2d,$j3d]
		writetolegs(movement, 1, 0)
		sleep 0.25
		movement = [$j1l,$j2d,$j3d,$j1r,$j2d,$j3d,$j1l,$j2d,$j3d,$j1r,$j2d,$j3d,$j1l,$j2d,$j3d,$j1r,$j2d,$j3d]
		writetolegs(movement, 1, 0)
		puts "I'm Switching!"
		sleep 0.25
	end
	stand
end



def move(position)

case position

when "frontstand"
	fstand = [150,140,144,150,140,144,150,156,156,150,156,156,150,172,168,150,172,168]
	writetolegs(fstand,1,0)

when "tripodright"
	stand
	sleep 0.5
	tresright = [$j1m,$j2u+20,$j3u+20,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2u+20,$j3u+20,$j1m,$j2u-20,$j3u+20,$j1m,$j2d,$j3d]
	writetolegs(tresright,1,0)

when "tripodleft"
	stand
	sleep 0.5
	tresleft = [$j1m,$j2d,$j3d,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2u,$j3u]
	writetolegs(tresleft,1,0)

when "updownX5"
	for m in 0..4
		stand
		sleep 0.5
		laydown
		sleep 0.25
	end

when "lift3legs"
	stand
	sleep 1
	move("tripodright")
	sleep 0.5
	stand
	sleep 1
	move("tripodleft")
	sleep 0.5
	laydown

when "wave"
	move("frontstand")

	while i < 4

		puts "wave up"
		sleep 0.25

		puts leg
		puts "wave down"
		i+=1
		sleep 0.25
	end
	sleep 1

	#leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
	#my_serial.write(leg)
	move("laydown")
	move("reset")
	end
end

end
def testing(data)
	crab = Crab.new
	puts "#{data}"
	leg_hash = Hash[*data]
	puts "#{leg_hash}" # it goes this far
	leg_hash.each { |key, val|
		case key
			when "Leg"
				leg = val
			when "pos1"
				pos1 = val
			when "pos2"
				pos2 = val
			when "pos3"
				pos3 = val
			when "reset"
				crab.reset
				return key
			when "stand"
				crab.stand
				return	key
			when "laydown"
				crab.laydown
				return key
		end
		puts "#{key} => #{val}"
	}
	$leg_to_test = leg_hash["Leg"].to_i
	$test_j1 = leg_hash["pos1"].to_i
	$test_j2 = leg_hash["pos2"].to_i
	$test_j3 = leg_hash["pos3"].to_i
	crab.test_leg($leg_to_test, $test_j1,$test_j2, $test_j3)
end
end
#srvr
