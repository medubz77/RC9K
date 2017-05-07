# Require GUI toolkit
#require 'green_shoes'

class Calibrator
  def initialize
    @@current_leg = []
    @@leg_array = []
    @@leg_string = ""
  end
  # Method to set leg joint positions
  def set_leg(leg,pos1,pos2,pos3)
#	set_leg = pos1,pos2,pos3
	if !@@current_leg.include?(leg)
		@@leg_string = @@leg_string + "#{pos1},#{pos2},#{pos3},"
		#@@leg_array = @@leg_array.insert(-1, pos1,pos2,pos3)
		@@current_leg << leg
		puts "Leg: #{@@current_leg} - Full Leg Array: #{@@leg_string.chop}"
	else
		puts "Already set leg #{leg}"
	end
  end
# Write values to csv file
  def write
File.open('calibration.conf', 'w') { |file| file.write(@@leg_string.chop) }
#    CSV.open('calibration.conf.csv', 'w') do |csv_conf|
#      @@leg_array.each do |row_array|
#       csv_conf = row_array
#      end
#    end
  end
end
