require 'opencv'
include OpenCV
system("python GrabImage.py") # This will return true

#if ARGV.length < 2
#  puts "Usage: ruby #{__FILE__} source dest"
#  exit
#end
def FaceDetect
data = '/home/pi/rc9k/opencv_data/haarcascades_GPU/haarcascade_frontalface_alt.xml'
detector = CvHaarClassifierCascade::load(data)
#image = CvMat.load(ARGV[0])
image = CvMat.load("image.png")
detector.detect_objects(image).each do |region|
  color = CvColor::Blue
  image.rectangle! region.top_left, region.bottom_right, :color => color
end

#image.save_image(ARGV[1])
image.save_image("test_image.png")
window = GUI::Window.new('detection')
window.show(image)
GUI::wait_key
end
original_window = GUI::Window.new "original"
hough_window = GUI::Window.new "hough circles"

image = IplImage::load "image.png"
gray = image.BGR2GRAY

result = image.clone
original_window.show image
detect = gray.hough_circles(CV_HOUGH_GRADIENT, 2.0, 10, 200, 50)
puts detect.size
detect.each{|circle|
  puts "#{circle.center.x},#{circle.center.y} - #{circle.radius}"
  result.circle! circle.center, circle.radius, :color => CvColor::Red, :thickness => 3
}
hough_window.show result
GUI::wait_key
