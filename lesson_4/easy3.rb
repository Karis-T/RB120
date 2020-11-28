#1
"Hello"

#undefined method

#argument error

"Goodbye"

#undefined method

#2
#either Hello.new.hi
#or invoke with Hello.hi and def self.hi; Hello.new.greet("Hello"); end

#3
binny = AngryCat.new(17, "Binny Cat")
gus = AngryCat.new(3, "Butty")
#pass a different set of arguments to the constructor method

#4
def to_s
  "I am a #{@type} cat"
end

#5
#undefined instance method manufacturer
#return value of last line of tv.model
#return value of last line of self.manufacturer
#undefined class method model

#6
def make_one_year_older
  @age += 1
end
#self and @ are the same thing and can be used interchangeably

#7
def information
  "I want to turn on the light with a brightness level of #{brightness} and a color of #{color}"
end

p Light.new("super hi", "green").information