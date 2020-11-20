module Trunk
  def open_trunk
    "trunk is opened!"
  end
end

class Vehicle
  @@vehicles_made = 0

  attr_accessor :color
  attr_reader :year

  def initialize(y, m, c)
    @year = y
    @color = c
    @model = m
    @speed = 0
    @@vehicles_made += 1
  end

  def self.display_vehicle_count
    puts @@vehicles_made
  end

  def self.gas_milage(miles, gallons)
    puts "#{miles / gallons} mpg"
  end

  def year_info
    "My vehicle was made in the year #{self.year}"
  end

  def color_info
    "My vehicle color is #{self.color}"
  end

  def spray_paint(c)
    self.color = c
    puts "Your new #{self.color} paint job looks great!"
  end

  def speed_up(num)
    @speed += num
  end

  def brake(num)
    @speed -= num
  end

  def turn_off
    @speed = 0
  end

  def current_speed
    puts "You are now going #{@speed} mph."
  end

  def to_s
    "#{@year}, #{@model}, #{@color}"
  end

  private
  def age
    Time.now.year - year
  end
end


class MyCar < Vehicle
  include Trunk
  CAR = "car"
end

class MyTruck < Vehicle
  TRUCK = "truck"
end


toyota = MyCar.new(2007, "Toyota Yaris", "aquamarine")
ford = MyCar.new(1999, "Ford Ute", "white")
Vehicle.display_vehicle_count

# puts MyCar.ancestors
# puts "-----------"
# puts MyTruck.ancestors
# puts "-----------"
# puts Vehicle.ancestors

puts toyota
MyCar.gas_milage(351, 13)

toyota.speed_up(20)
toyota.current_speed
toyota.speed_up(10)
toyota.current_speed
toyota.turn_off
toyota.current_speed
puts toyota.year_info
puts toyota.color_info
toyota.spray_paint("midnight blue")
puts toyota.color_info

puts ford.year_info
puts ford.age