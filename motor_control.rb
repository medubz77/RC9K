require 'rpi_gpio'
RPi::GPIO.set_numbering :board # sets the pin number to the board physical pins
RPi::GPIO.setup 3, :as => :output, :initialize => :low #setting the intial state for the pin as low
class MotorPower

  def toggle(state)
    if state == "on"
      RPi::GPIO.set_high 3
    elsif state == "off"
      RPi::GPIO.set_low 3
    end
  end
end
#hardware note.GPIOs can handle 16 MA per pin, with all gpios at 54ma.  to pull 10 MA from GPIO for relay,
#3.3-.7=2.6    2.6/.01=260 ohms, go with about a 250 ohm resistor instead of the 1kohm in there now.
