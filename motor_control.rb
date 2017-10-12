require 'rpi_gpio'
RPi::GPIO.set_numbering :board
RPi::GPIO.setup 2, :as => :output, :initialize => :low #setting the intial state for pin 3 as low
class MotorPower

  def toggle(state)
    if state == "on"
      RPi::GPIO.set_high 2
    elsif state == "off"
      RPi::GPIO.set_low 2
    end
  end
end
