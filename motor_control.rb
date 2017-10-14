require 'rpi_gpio'
RPi::GPIO.set_numbering :board # sets the pin number to the board physical pins
RPi::GPIO.setup 7, :as => :output, :initialize => :low #setting the intial state for the pin as low
RPi::GPIO.setup 15, :as => :output, :initialize => :high  #  pi CPU state on
Rpi::GPIO.setup 11, :as => :input, :pull=>:up  #moton off control pin
Rpi::GPIO.setup 13 :as => :input, :pull=>:up  #halt pin
class MotorPower
state="off"


def motors_off
RPi::GPIO.set_low 7
end

def check_switch
if Rpi::GPIO.low? 11
toggle()
sleep 1000
end
if Rpi::GPIO.low?  13
Rpi::GPIO.set_low 15
puts "HALTING"
cmd='halt'

end
end


def toggle
  if state == "on"
    RPi::GPIO.set_high 7
    state="off"
  elsif state == "off"
    RPi::GPIO.set_low 7
    state="on"
  end
end




  def toggle(state)
    if state == "on"
      RPi::GPIO.set_high 7
    elsif state == "off"
      RPi::GPIO.set_low 7
    end
  end
end
#hardware note.GPIOs can handle 16 MA per pin, with all gpios at 54ma.  to pull 10 MA from GPIO for relay,
#3.3-.7=2.6    2.6/.01=260 ohms, go with about a 250 ohm resistor instead of the 1kohm in there now.
#also note that pins 3 and 5 should not be used for relay control as they are ic2 lines and we may want them in the future
