require './bots'

include Bots

# models the hexapod
class Hexapod < Controller

  def initialize(type=:sim)
    super(type)
    @legs = {}
    @legs[:front_left]   = Leg3DOF.new(:left, 1, 2, 3)
    @legs[:middle_left]  = Leg3DOF.new(:left, 4, 5, 6)
    @legs[:back_left]    = Leg3DOF.new(:left, 7, 8, 9)

    @legs[:front_right]  = Leg3DOF.new(:right, 32, 31, 30)
    @legs[:middle_right] = Leg3DOF.new(:right, 29, 28, 27)
    @legs[:back_right]   = Leg3DOF.new(:right, 26, 25, 24)

    @left_legs = [:front_left, :middle_right, :back_left]
    @right_legs = [:front_right, :middle_left, :back_right]
  end

  # move given leg by rotating the 3 servos by the given degrees
  def move(leg, c, f, t)
    execute @legs[leg].actuate(c, f, t)
  end

  def lift_straight(leg)
    leg.actuate 90, 45, 110
  end

  def ground_straight(leg)
    leg.actuate 90, 100, 70
  end

  def lift_pull(leg)
    leg.actuate 120, 45, 110
  end

  def ground_pull(leg)
    leg.actuate 120, 100, 70
  end
  def all
    execute(@legs.values.inject("") do |memo, leg|
      memo + yield(leg)
    end)
  end
end
