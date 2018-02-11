#!/usr/bin/env ruby
# face_detect.rb
require "rubygems"
require "opencv"

include OpenCV

window = GUI::Window.new("face detect")
capture = CvCapture.open
facerec = File.expand_path("./opencv_data/haarcascades/haarcascade_frontalface_alt.xml")
detector = CvHaarClassifierCascade::load("#{facerec}")
#detector = CvHaarClassifierCascade::load("./opencv_data/haarcascades/haarcascade_frontalface_alt.xml")
puts facerec
loop {
  image = capture.query
#  detector.detect_objects(image).each { |rect|
#    image.rectangle! rect.top_left, rect.bottom_right, :color => CvColor::Red
#  }
  window.show image
  break if GUI::wait_key(100)
}
