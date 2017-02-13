#require File.join(File.dirname(__FILE__),'config/application.rb')
class DoSomething
  def initialize

  end

  def do_this(action)
    puts "Look at me, I'm #{action}"
  end

  def breathe_in_and_out(times)
    times.each do |time|
        puts "#{time} thousand."
        sleep(1)
    end
  end


end
