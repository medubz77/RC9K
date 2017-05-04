# Require the library
require 'rubyserial'

class Crab

# Instantiate global variables
def initialize

# leg position costants
	$j1l=120
	$j1m=150
	$j1r=180
	$j2u=150
	$j2d=120
	$j3u=140
	$j3d=230
	$legs=[150, 150, 140,150, 150, 140,150, 150, 140, 150, 150, 140,150, 150, 140,150, 150, 140]
	$tomove=[150, 150, 140,150, 150, 140,150, 150, 140, 150, 150, 140,150, 150, 140,150, 150, 140]
	$periter=[150, 150, 140,150, 150, 140,150, 150, 140, 150, 150, 140,150, 150, 140,150, 150, 140]

end
# Get data and do whatever you want with it
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
	my_serial = Serial.new("/dev/ttyACM0", 115200)
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
	my_serial = Serial.new("/dev/ttyACM0", 115200)
	#legs = [0,1,2,3,4,5]
	#legs.each do |leg|
	move_leg = "Leg(#{leg},#{pos1},#{pos2},#{pos3})"
	my_serial.write(move_leg)
	puts "#{move_leg}"
	#sleep 0.05
	#end
	my_serial.close
	my_serial = nil
end


def writetolegs(pos, steps, time)
	my_serial = Serial.new("/dev/ttyACM0", 115200)
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

		my_serial.write("Leg(3,#{$legs[9]},#{$legs[10]},#{$legs[11]})")

		my_serial.write("Leg(4,#{$legs[12]},#{$legs[13]},#{$legs[14]})")

		my_serial.write("Leg(5,#{$legs[15]},#{$legs[16]},#{$legs[17]})")
		sleep 0.025
		puts steps
	end
	my_serial.close
	my_serial = nil
end

def dumb_walk(steps)
	move("standup")
	sleep 5
	move("tripodright")
	while steps > 0
		steps = steps - 1
		walk_right = [170,140,144,150,130,212,130,170,169,130,140,144,170,140,144,170,170,169]
		writetolegs(walk_right,1,0)
		puts "walked right"
		sleep 5
		poise_right = [170,170,169,170,130,212,130,170,169,130,170,169,170,170,169,170,170,169]
		writetolegs(poise_right,1,0)
		puts "poised right"
		sleep 5
		switch_right = [170,170,169,170,140,144,130,140,144,130,170,169,170,170,169,170,140,144]
		writetolegs(switch_right,1,0)
		puts "switched right"
		sleep 5
		walk_left = [130,170,169,130,140,144,170,140,144,170,170,169,130,140,144,130,140,144]
		writetolegs(walk_left,1,0)
		puts "walked left"
		sleep 5
		poise_left = [130,170,169,130,170,169,170,170,169,170,170,169,130,170,169,130,170,169]
		writetolegs(poise_left,1,0)
		puts "poised left"
		sleep 5
		switch_left = [130,140,144,130,170,169,170,170,169,170,140,144,130,140,144,130,170,169]
		writetolegs(switch_left,1,0)
		puts "switched left"
		sleep 5
	end
	move("standup")
end

def walk(speed, gait)


end

def reset
	my_serial = Serial.new("/dev/ttyACM0", 115200)
	legs = [0,1,2,3,4,5]
	legs.each do |num|
		leg = "Leg(#{num},150,140,144)"
		puts leg
		my_serial.write(leg)
		sleep 0.05
	end
	puts "Reset Position"
end

def stand
	standpos = [$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d]
	writetolegs(standpos, 1, 0)
	puts "I'm Standing!"
end

def laydown
	laydownpos = [$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u]
	writetolegs(laydownpos, 5, 0.1)
	puts "Laying Down"
end

def attack
	standpos = [$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u]
	writetolegs(standpos, 1, 0)
	puts "I'm Attacking!"	
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
	tresright = [$j1m,$j2u,$j3u,$j1m,$j2d,$j3d,$j1m,$j2d,$j3d,$j1m,$j2u,$j3u,$j1m,$j2u,$j3u,$j1m,$j2d,$j3d]
	writetolegs(tresright,1,0)

when "tripodleft"
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
	#sleep 0.1
	#i=0
	#leg_num = 5
	#@@j2 = 109
	while i < 4
		#@@j3 = @@j3 - 35
		#leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
		#my_serial.write(leg)
		#puts leg
		puts "wave up"
		sleep 0.25
		#@@j3 = @@j3+=35
		#leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
		#my_serial.write(leg)
		puts leg
		puts "wave down"
		i+=1
		sleep 0.25
	end
	sleep 1
	#@@j1 = 150
	#@@j2 = 170
	#@@j3 = 169
	#leg = "Leg(#{leg_num},#{@@j1},#{@@j2},#{@@j3})"
	#my_serial.write(leg)
	move("laydown")
	move("reset")
	end
end

# method to make rc9k dance

# Close serial once you're done using it
#def stop_serial
#@@my_serial.close
#@@my_serial = nil
#end
#crab = Crab.new
#crab.move("standup")
end
