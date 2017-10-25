require 'thread'
class ReadData

  def startpython
  runthis= Thread.new{
    something=exec("python ball_tracking.py")
  }
  end

 def get_tempcamera_data
   runme = Thread.new{
     while (true)
       File.open("./tmp/tempcamera.txt").each do |line|
         $rawcamera=line
       end
       sleep 0.25
     end
    }
  end

end
