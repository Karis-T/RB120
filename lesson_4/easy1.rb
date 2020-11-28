#1
p true.class
p "hello".class
p [1, 2, 3, "happy days"].class
p 142.class

#2
module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

p truck = Truck.new.go_fast
p car = Car.new.go_fast

#3
#by including the Speed module in the Car class, the instance method go_fast is now availble to all Car objects. Here the go_fast method is being called by a car object, where self inside an instance method refers to the calling object. When chained with the class method it will refer to the calling objects class, which in this case is Car

# We use self.class in the method and this works the following way:
#
# self refers to the object itself, in this case either a Car or Truck object.
# We ask self to tell us its class with .class. It tells us.
# We don't need to use to_s here because it is inside of a string and is interpolated which means it will take care of the to_s for us.

#4
class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

AngryCat.new

#5
#Pizza has an instance variable @name indicated by the @ symbol

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

hot_pizza = Pizza.new("cheese")
orange    = Fruit.new("apple")

>> hot_pizza.instance_variables # => [:@name]
>> orange.instance_variables # => []

# As you can see, if we call the instance_variables method on the instance of the class we will be informed if the object has any instance variables and what they are.

#6
class Cube
  attr_reader :volume
  def initialize(volume)
    @volume = volume
  end
  #or this method
  # def get_volume
  #   @volume
  # end
end

p cubed = Cube.new(3).volume

#techincally we don't need to add anything and use this method
big_cube = Cube.new(5000)
big_cube.instance_variable_get("@volume") #=> 5000

#7
# Object#to_s documentation:
# Returns a string representing obj.
#The default to_s prints the object’s class and an encoding of the object id.

#8
# since make_one_year_older is an instance method of the Cat class, so self here refers to the calling object, which in this case would be a cat object.

#9
# self.cats count is a class method within the Cat class. In this case self here means the class itself which would be Cat

#10
Bag.new("green", "plastic")
