#1
"You will eat a nice lunch" #or
"You will take a nap soon" #or
"You will stay at work late"

#2
"You will visit vegas" #or
"You will fly to fiji" #or
"You will romp in rome"
#Because the calling object is an Instance of RoadTrip and has the same method name as choices in its superclass, the instance will use Roadtrip choices method as it overrides Oracles method choices and comes first in the method lookup.

#3
#use the ancestors method on the class in question
Orange.ancestors
[Orange, Taste, Object, Kernel, BasicObject]

HotSauce.ancestors
[HotSauce, Taste, Object, Kernel, BasicObject]

#If the method appears nowhere in the chain then Ruby will raise a NoMethodError which will tell you a matching method can not be found anywhere in the chain.

#4

#remove
def type
  @type
end

def type=(t)
  @type = t
end

#add to the top of the class
attr_accessor :type

#change, remove the instance variable and use the getter method instead (standard practice)
def describe_type
  puts "I am a #{type} type of Bees Wax"
end

#5
#local variable (no prefix)
#instance variable (one @ symbol prefix)
#class variable (two @@ symbol prefixes)

#6
# a class method is prefixed with self. .Call this method with the class itself followed by the method name
# eg. Television.manufacturer
# an instance method contains no prefix

#7
# @@cats_count counts the number of objects instantiated/created from the Cat class,
# to test it out create a whole bunch of cat objects and then invoke the method
Cat.cats_count

#8
Bingo < Game

#9
#if you created a bingo object and then invoked the play method it would override the play method from the game class and use the bingo play method instead.

#10
#benefits are: less dependencies, more flexiblity, better scalability
#allows us to think about code abstractly, objects as nouns are easier to conceptualize
#expose functionality to parts of code that need it. Namspace issues are harder to come across
# It allows us to easily give functionality to different parts of an application without duplication.
# We can build applications faster as we can reuse pre-written code.
# As the software becomes more complex this complexity can be more easily managed.
