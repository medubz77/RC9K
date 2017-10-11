# face_detect.rb
require "rubygems"
require "opencv"

include OpenCV

window = GUI::Window.new("face detect")
capture = CvCapture.open
capture.fps= => 25
#detector = CvHaarClassifierCascade::load("/home/pi/tmp/opencv/data/haarcascades_GPU/haarcascade_frontalface_alt2.xml")
detector = CvHaarClassifierCascade::load("/usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml")

loop {
  image = capture.query
  detector.detect_objects(image).each { |rect|
    image.rectangle! rect.top_left, rect.bottom_right, :color => CvColor::Red
  }
  window.show image
  break if GUI::wait_key(100)
}
