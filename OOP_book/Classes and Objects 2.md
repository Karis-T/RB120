# Classes and objects 2

---

## Class Methods:

- instance methods are methods that are reserved for an instance of object of their class. 
- class methods are called directly on the class itself without having to instantiate objects.
- class methods are for functions that don't relate to individual objects.
- objects have states/attributes but if we have a method that doesn't need states then we can use a class method.

## Class Variables:

- instance variables capture information related to individual objects in a given class
- class variables keep track of class level detail that relates only to a particular class and not individual objects
- class variables start with @@
- we can access class variables from within instance methods
- when `self` is used to define a class method self refers to the class itself (`GoodDog`)

```ruby
class GoodDog
  @@number_of_dogs = 0 #class variable initialized to 0

  def initialize # constructor (auto called for every instantiation)
    @@number_of_dogs += 1 # we can access class variables from instance method (initialize)
  end

  def self.total_number_of_dogs # same as GoodDog.total_number_of_dogs
    @@number_of_dogs
  end
end

puts GoodDog.total_number_of_dogs   # => 0

dog1 = GoodDog.new
dog2 = GoodDog.new

puts GoodDog.total_number_of_dogs   # => 2
```



## Constants:

- certain variables in a class you never want to change

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n 								 #name setter method
    self.age  = a * DOG_YEARS 			#age setter method
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky.age   								# => 28 (used age getter method)
```

- long version:

```ruby
class GoodDog
  DOG_YEARS = 7
  
  def name=(n) #name setter method
    @name = n
  end
  
  def age=(a) #age setter method
    @age = a
  end
  
  def name
    @name
  end
 
  def age 
    @age
  end
  
  def initialize(n, a)
    self.name=(n)							# invoking name setter method							 
    self.age=(a * DOG_YEARS)	 # invoking age setter method
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky.age 							# invoking age getter method 
```



## The to_s Method:

- comes built into every class in ruby
- use string interpolation to print out the object or call the to_s method

```ruby
#class GoodDog
  def to_s
   "#{name}, #{age}"
  end
#end

sparky = GoodDog.new("Sparky", 4)
puts sparky # => Sparky, 4
```



## More About Self:

- `self` can refer to different things depending on where its used:

- use `self` when:

  -  invoking setter methods from INSIDE the class to know the difference between initializing a local variable and invoking a setter method

  - class method definitions

- use `self` whenever you want to invoke an instance method from within the class

- **when an instance method uses `self` from within a class it refers to the calling object.** in this case its the `sparky` object

- **when `self` is used to define a class method self refers to the class itself** in this case its the `GoodDog` class

```ruby
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    self.name=(n)
    self.height=(h)
    self.weight=(w)
  end

  def change_info(n, h, w)
    self.name=(n)			#the same as sparky.name = n
    self.height=(h)		#the same as sparky.age = a
    self.weight=(w)		#the same as sparky.weight = w
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end
end
```

To be clear, from within a class...

1. **`self`, inside of an instance method, references the instance (object)** that called the method - the calling object. Therefore, `self.weight=` is the same as `sparky.weight=`, in our example.
2. **`self`, outside of an instance method, references the class** and can be used to define class methods. Therefore if we were to define a `name` class method, `def self.name=(n)` is the same as `def GoodDog.name=(n)`

- `self` changes depending on the scope it is used in, so pay attention to see if you're inside an instance method or not.



