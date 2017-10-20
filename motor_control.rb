require 'rpi_gpio'
RPi::GPIO.set_numbering :board # sets the pin number to the board physical pins
RPi::GPIO.setup 15, :as => :output, :initialize => :low #setting the intial state for the pin as low, motor control line
RPi::GPIO.setup 16, :as => :output, :initialize => :high  #  pi CPU state on
RPI::GPIO.setup 7, :as => :input  #now used for sonar eco line
RPI::GPIO.setop 12, as => :output, :initialze => :low # sonar trigger line
RPi::GPIO.setup 11, :as => :input, :pull=>:up  #moton off control pin
RPi::GPIO.setup 13, :as => :input, :pull=>:up  #halt pin
RPI::GPIO.setup 18, :as => :output, :initialize => :low  #LED
RPI::GPIO.setup 22, :as => :output, :initialize => :low  #LED
class MotorPower
state="off"


def motors_off
RPi::GPIO.set_low 15
end

def check_switch
if RPi::GPIO.low? 11
togglemotorpower
sleep 1000
end
if RPi::GPIO.low?  13
RPi::GPIO.set_low 16
motors_off
puts "HALTING"
cmd='halt'

end
end


def togglemotorpower
  if state == "on"
    RPi::GPIO.set_high 15
    state="off"
  elsif state == "off"
    RPi::GPIO.set_low 15
    state="on"
  end
end




  def toggle(state)
    if state == "on"
      RPi::GPIO.set_high 15
    elsif state == "off"
      RPi::GPIO.set_low 15
    end
  end
end
#hardware note.GPIOs can handle 16 MA per pin, with all gpios at 54ma.  to pull 10 MA from GPIO for relay,
#3.3-.7=2.6    2.6/.01=260 ohms, go with about a 250 ohm resistor instead of the 1kohm in there now.
#also note that pins 3 and 5 should not be used for relay control as they are ic2 lines and we may want them in the future
