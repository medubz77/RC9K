require "rubygems"
require "filewatch/tail"

t = FileWatch::Tail.new
t.tail("/home/pi/rc9k/tmp/tempcamera.txt")
t.subscribe do |path, line|
  puts "#{path}: #{line}"
end
