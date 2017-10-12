require 'rpi_gpio'
RPi::GPIO.set_numbering :board 
class MotorPower
  RPi::GPIO.setup 3, :as => :output, :initialize => :low #setting the intial state for pin 3
  def toggle(state)
    if state == "on"
      RPi::GPIO.set_high 3
    elsif state == "off"
      RPi::GPIO.set_low 3
    end
  end
end
