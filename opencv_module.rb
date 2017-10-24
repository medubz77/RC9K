require 'opencv'
include OpenCV
system("python GrabImage.py") # This will return true

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

data = './opencv_data/haarcascades/haarcascade_frontalface_alt.xml'
detector = CvHaarClassifierCascade::load(data)
#image = CvMat.load(ARGV[0])
image = CvMat.load("./image.png")
detector.detect_objects(image).each do |region|
  color = CvColor::Blue
  image.rectangle! region.top_left, region.bottom_right, :color => color
end

#image.save_image(ARGV[1])
image.save_image("test_image.png")
window = GUI::Window.new('detection')
window.show(image)
GUI::wait_key
