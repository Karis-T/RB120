class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Cat < Pet
  def speak
    "meow!"
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def fetch
    'fetching!'
  end

  def swim
    'swimming!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

bowser = Bulldog.new
puts bowser.speak           # => "bark!"
puts bowser.swim           # => "swimming!"

kitty = Cat.new
puts kitty.speak
puts kitty.run

puts "---Bulldog ancestors---"
p Bulldog.ancestors
puts ''
puts "---Cat ancestors---"
p Cat.ancestors

# Pet
# run
# jump
#  |   \
# Dog  Cat
# speak speak
# fetch
# swim
#  |
# Bulldog
# swim