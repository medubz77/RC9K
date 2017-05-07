#require 'green_shoes'
#require 'net-ssh'
require 'calibrator.rb'
Shoes.app do
  stack width: 150 do
    para "Choose a Leg:"
    list_box width: 50, items: ["0", "1", "2", "3", "4", "5"]
  end
  
end
