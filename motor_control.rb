require 'rpi_gpio'
$motorpin =15
$unusedLED=16
$sonarin=7
$sonarout=12
$motorbutton=11
$haltbutton=13
$motorLED=18
$stateLED=22

RPi::GPIO.set_numbering :board # sets the pin number to the board physical pins
RPi::GPIO.setup 15, :as => :output, :initialize => :low #setting the intial state for the pin as low, motor control line
RPi::GPIO.setup 22, :as => :output, :initialize => :high  #  pi CPU state on
RPi::GPIO.setup 7, :as => :input  #now used for sonar eco line
RPi::GPIO.setup 12, :as => :output, :initialze => :low # sonar trigger line
RPi::GPIO.setup 11, :as => :input, :pull=>:up  #moton off control pin
RPi::GPIO.setup 13, :as => :input, :pull=>:up  #halt pin
RPi::GPIO.setup 18, :as => :output, :initialize => :low  #LED motorLED
RPi::GPIO.setup 16, :as => :output, :initialize => :low  #LED
class MotorPower
$motorstate="off"
$ledstate="off"

def sonarPing
RPi::GPIO.set_high $sonarout
sleep 0.001
start_time=Time.now
end_time=start_time
RPi::GPIO.set_low $sonarout
while ((RPi::GPIO.low? $sonarin)&& (end_time-start_time<1))
    end_time=Time.now
  end
elapsed_time=end_time-start_time
puts elapsed_time
distance=(elapsed_time*34300)/2
#puts distance
return distance
end



def motors_off
RPi::GPIO.set_low $motorLED
  RPi::GPIO.set_low $motorpin
$motorstate="off"
end


def motors_on
  RPi::GPIO.set_high $motorpin
  RPi::GPIO.set_high $motorLED
$motorstate="on"
end

def check_switch
fork do
  while (true)
    RPi::GPIO.set_low $stateLED
    sleep 0.5
RPi::GPIO.set_high $statLED
  #togglestateLED
  if RPi::GPIO.high? $motorbutton

      togglemotorpower
      sleep 1
    end
    if RPi::GPIO.high?  $haltbutton
      RPi::GPIO.set_low $stateLED
      motors_off
      puts "HALTING"
      cmd='halt'

    end

end

end

end

def togglestateLED
  if $ledstate == "on"
    RPi::GPIO.set_high $stateLED
    $ledstate="off"
  else
    RPi::GPIO.set_low $stateLED
    $ledstate="on"
end
end


def togglemotorpower
  if $motorstate == "on"
    RPi::GPIO.set_high $motorpin
    $motorstate="off"
RPi::GPIO.set_high $motorLED
  elsif $motorstate == "off"
    RPi::GPIO.set_low $motorpin
    RPi::GPIO.set_low $motorLED
    $motorstate="on"
  end
end




  def toggle(state)
    if state == "on"
      RPi::GPIO.set_high $motorpin
      RPi::GPIO.set_high $motorLED
      $motorstate="on"
    elsif state == "off"
      RPi::GPIO.set_low $motorLED
      RPi::GPIO.set_low $motorpin
      $motorstate=""
    end
  end
end
#hardware note.GPIOs can handle 16 MA per pin, with all gpios at 54ma.  to pull 10 MA from GPIO for relay,
#3.3-.7=2.6    2.6/.01=260 ohms, go with about a 250 ohm resistor instead of the 1kohm in there now.
#also note that pins 3 and 5 should not be used for relay control as they are ic2 lines and we may want them in the future
