
require 'file/tail'

#filename = ARGV.pop or fail "Usage: #$0 number filename"
#number = (ARGV.pop || 0).to_i.abs
filename = "./tmp/tempcamera.txt"
File::Tail::Logfile.open(filename) do |log|
  log.forward(10).tail { |line| puts line }
end
