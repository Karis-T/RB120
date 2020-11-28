#1
# they're both right because we have a getter method balance which retrieves the @balance. @balance alone will work too

#2
#Alyssa's right because there's no setter method
#use attr_accessor :quantity
#call using self.quantity=()
#that or reference the @quantity directly

#3 yes it can be accessed outside the method. To remedy this you can use the private keyword to prevent it from being accessed outside the class

#4
class Greeting
  def greet(str)
    puts str
  end
end

class Hello < Greeting
  def hi
    greet("hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

#5
def to_s
  if @filling_type.nil? && @glazing.nil?
    "Plain"
  elsif @glazing.nil? && @filling_type
    "#{@filling_type}"
  elsif @filling_type.nil? && @glazing
    "Plain with #{@glazing}"
  else
    "#{@filling_type} with #{@glazing}"
  end
end

def to_s
  filling_string = @filling_type ? @filling_type : "Plain"
  glazing_string = @glazing ? " with #{@glazing}" : ''
  filling_string + glazing_string
end

#6
# the first one uses assignment and initialisation of @template and the getter method
# the second one uses a setter method using self.template
# and the getter method
# Both examples are technically fine, however, the general rule from the Ruby style guide is to "Avoid self where not required."

#7
#Light.information
#Light.status
