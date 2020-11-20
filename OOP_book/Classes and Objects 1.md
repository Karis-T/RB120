# Classes and Objects 1

---

## States and Behaviours:

- When defining a class we focus on 2 things: states and objects
- **States** track attributes for individual objects. (instance variables)
- **Behaviors** are what objects are capable of doing (instance methods)

```
Using our GoodDog class from earlier, we create two GoodDog objects:
- Fido
- Sparky
Fido and Sparky are 2 GoodDog objects but may contain different information such as:
- name
- weight
- height
even though sparky and fido are 2 different objects they are still objects (or instances) of the class GoodDog
Eg. Both GoodDog objects should be able to bark, run, fetch and perform other common behaviours of good dogs.
bark run and fetch are instance methods defined in a class.
```

- **Instance variables** are scoped at the object (or instance) level, and how objects keep track of their states
- **Instance methods** defined in a class are available to objects (or instances) of that class. help keep track of an objects behavior

## Initializing a New Object:

```ruby
class GoodDog
  def initialize
    puts "This object was initialized!"
  end
end

sparky = GoodDog.new        # => "This object was initialized!"
#instantiating a new GoodDog object triggered the initialize method and resulted in the string being outputted
```

- The `initialize` method is invokes every time you create a new object. 
- `initialize` method is known as a **constructor**, as it gets triggered every time we create an object.
- the `initialize` method has a special purpose in ruby: 
  - the `new` method of the class object creates a new instance object and then it **automatically** invokes the `initialize` method on that instance. 
  - You pass arguments into the `initialize` method via the `new` method 
  - The `initialize` method is automatically made private. ie. An object can call `initialize` on itself but you cannot call `initalize` on a local variable to reinitialize its state

```ruby
class Point
	def initialize(x,y)
		@x, @y = x, y
	end
end

p = Point.new(0,0)
# Because our `initalize` method expects 2 arguments we now must supply 2 values when we invoke `Point.new`
```

## Instance Variables:

```ruby
class GoodDog
  def initialize(name)
    @name = name
  end
end

sparky = GoodDog.new("Sparky")
#The string "Sparky" is being passed from the new method through to the initialize method and assigned to the local variable name.

#Within the constructor (initialize method) we then set the instance variable @name to name, which results in assigning the string "Sparky" to the @name instance variable.

#In the code above, the sparky object's name is the string "Sparky". 
#This state for the object is tracked in the instance variable @name.
```

- The `@name` is an instance variable. It exists for as long as the object instance exists.
- **instance variables are one of the ways we tie data to objects**. 
- Instance variable don't die after the initialize method is run. It "lives on" to be references until the object instance is destroyed. 
- Every objects start is unique and instance variables are responsible for keeping track of information about the **state** of each object. In this case the differing state is the name. 
- Instance variables begin with an `@` and they always belong to whatever object the class refers to. 
- Each instance (`Sparky` and `Fido`) of the `GoodDog` class have their own copy of the variables `name`

## Instance Methods:

- All objects of the same class have the same behaviors
- Instance methods expose information about the state of the object.
- Ruby objects are strictly encapsulated. The instance variables (states) of an object can only be accessed by the instance methods of that object.
- Code that isn't inside an instance method won't be able to read or set the value of an instance variable 

## Accessor Methods:

- getter and setter methods are a way to expose and change an objects state
- if you want to **retrieve** sparky's name, which is stored in the `@name` instance variable, we have to create a method that will only do one thing - return the value in the `@name` instance variable. If this isn't done a `NoMethodError` is raised.
- These methods are known as **getter methods**
- If you want to **change** sparky's name then you have to create a **setter** method

```ruby
class GoodDog
  def initialize(name)
    @name = name
  end

  def get_name			 #getter method
    @name
  end

  def set_name=(name) #setter method
    @name = name
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
puts sparky.get_name
sparky.set_name = "Spartacus"
puts sparky.get_name
```

- To use the `set_name=` method normally, we would expect to do this: 
  `sparky.set_name=("Spartacus")`, 
  where the entire "set_name=" is the method name, and the string "Spartacus" is the argument being passed in to the method. 
-  When you see this code, just realize there's a method called `set_name=` working behind the scenes, and we're just seeing some Ruby *syntactical sugar*.
- Finally, as a convention, Rubyists typically wants *getter* and *setter* methods to be the same name as the instance variable they're exposing and setting

```ruby
  def name #getter method
    @name
  end

  def name=(n) #setter_method
    @name = n
  end
```

- *getter* and *setter* methods take up a lot of room in our program for such a simple feature.
- Because these methods are so commonplace, Ruby has a built-in way to automatically create these *getter* and *setter* methods for us, using the **attr_accessor** method

```ruby
class GoodDog
  attr_accessor :name #getter and setter method
  
  def initialize(name)
    @name = name
  end
  
  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
puts sparky.name            # => "Sparky"
sparky.name = "Spartacus"
puts sparky.name            # => "Spartacus"
```

- `attr_accessor` method takes a symbol as an argument, which it uses to create the method name for both getter and setter methods. 
- if you only want getter method and not a setter use `attr_reader`
- if you only want a setter method and not a getter use `attr_writer`
- to track multiple attributes/states of an objects:

```ruby
attr_accessor :name, :height, :weight
```

- you can use getter and setter methods from within the class as well 
- for the `speak` method in our class instead of referencing the instance variable, we want to invoke the `name` getter method directly.

so from:

```ruby
def speak
  "#{@name} says arf!" #name instance variable
end
```

to:

```ruby
def speak
  "#{name} says arf!" #getter method call
end
```

- using the getter method allows us to cut a lot of the work down
- say you only wanted to expose the last 4 digits of a credit card. if you're referencing the instance variable you'd have to keep editing the entire number to only display the last 4 digits again and again
- but if you reference the getter method, you can make the change in 1 place 

- for setter methods you must use the `self` reserved word to prevent ruby from thinking that you're trying to create a local variable

so from:

```ruby
def change_info(n, h, w)
  name = n
  height = h
  weight = w
end
```

to:

```ruby
def change_info(n, h, w)
  self.name = n
  self.height = h
  self.weight = w
end
```

