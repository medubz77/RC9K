require "rubygems"
require "opencv"

include OpenCV

window = GUI::Window.new("detect")
capture = CvCapture.open
detector = CvHaarClassifierCascade::load("./opencv_data/haarcascades_GPU/haarcascade_frontalface_alt.xml")

loop {
  image = capture.query
  detector.detect_objects(image).each { |rect|
    image.rectangle! rect.top_left, rect.bottom_right, :color => CvColor::Red
  }
  puts "#{capture}"
  window.show image
  break if GUI::wait_key(100)
}
