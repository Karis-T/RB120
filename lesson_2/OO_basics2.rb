class Cat
  def self.generic_greeting
    puts "Hello I'm a cat!"
  end
end


kitty = Cat.new
kitty.class.generic_greeting

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename(string)
    self.name=(string)
  end

end

kitty = Cat.new('Sophie')
p kitty.name
kitty.rename('Chloe')
p kitty.name

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def identify
    self
  end
end

kitty = Cat.new('Sophie')
p kitty.identify

#<Cat:0x007ffcea0661b8 @name="Sophie">


=begin
:: genereic greeting
# personal greeting
Hello! I'm a cat!
Hello! My name is Sophie!
=end


class Cat
  attr_reader :name
  def initialize(name)
    @name = name
  end
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
  def personal_greeting
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting

class Cat
  @@cat_total = 0
  def initialize
    @@cat_total += 1
  end
  def self.total
    puts @@cat_total
  end
end

kitty1 = Cat.new
kitty2 = Cat.new

Cat.total

=begin
Using the following code, create a class named Cat that prints a greeting when #greet is invoked. The greeting should include the name and color of the cat. Use a constant to define the color.

Expected output:
Hello! My name is Sophie and I'm a purple cat!
=end

class Cat
  COLOR = "purple"
  def initialize(name)
    @name = name
  end
  def greet
    puts "Hello! My name is #{@name} and I'm a #{COLOR} cat!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet

class Cat
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def to_s
    "I'm #{name}!"
  end
end

kitty = Cat.new('Sophie')
puts kitty

class Person
  attr_writer :secret

  private

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret

class Person
  attr_writer :secret
  def share_secret
    puts secret
  end

  private
  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret

=begin
Using the following code, add an instance method named compare_secret that compares the value of @secret from person1 with the value of @secret from person2.

expected output false
=end

class Person
  attr_writer :secret

  def compare_secret(object)
    secret == object.secret
  end

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

puts person1.compare_secret(person2)