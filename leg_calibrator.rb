require 'csv'
class Calibrator
  def initialize
    $leg_array = []
  end
  def calibrate_leg(leg,pos1,pos2,pos3)
    set_leg = [leg,pos1,pos2,pos3]
    $leg_array << set_leg

    puts "#{$leg_array}"


  end
  def write_to_file(data)
    CSV.open('calibration.conf.csv', 'w') do |csv_conf|
      data.each do |row_array|
        csv_conf << row_array
      end
    end
  end
# End class
end
