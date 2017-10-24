require 'file/tail'

#filename = ARGV.pop or fail "Usage: #$0 number filename"
#number = (ARGV.pop || 0).to_i.abs
filename = "/home/pi/rc9k/tmp/tempcamera.txt"
File::Tail::Logfile.open(filename) do |log|
  log.backward(1).tail { |line| 
puts line
puts "#{filename}"
 }
end
