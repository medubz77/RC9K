require 'thread'
require 'opencv'
include OpenCV
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
  def CameraCap
    fps = 15
    input = CvCapture.open
    win = GUI::Window.new 'video'
      loop do
        img = input.query
        win.show img
        key = GUI.wait_key 1000 / fps
        break if key and key.chr == "\e"
      end
  end
end
