while (true)
  File.open("./tmp/tempcamera.txt").each do |line|
    puts line
  end
  sleep 0.25 
end
