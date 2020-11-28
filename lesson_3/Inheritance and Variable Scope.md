# Inheritance and variable scope

---

## Instance Variables:

- **Instance Variables** behave the way we'd expect. The only thing to watch out for is to make sure the instance variable is initialized before referencing it.
- behave really similar to how instance methods would
- only difference is that in order to use a variable we must call the method that initializes the instance variable. Once we've done that, the instance can access that instance variable.

```ruby
class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def dog_name
    "bark! bark! #{@name} bark! bark!"    # can @name be referenced here?
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name                       # => bark! bark! Teddy bark! bark!
```

- you can access a superclass' instance variable from a subclass instance method
- the `Dog` class doesn't have an `initialize` instance method, the method lookup path went to the super class, `Animal`, and executed `Animal#initialize`. That's when the `@name` instance variable was initialized, and that's why we can access it from `teddy.dog_name`

```ruby
class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def initialize(name); end

  def dog_name
    "bark! bark! #{@name} bark! bark!"    # can @name be referenced here?
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name                       # => bark! bark! bark! bark!
```

- however here method lookup finds `@name` in the subclass as `nil` and the `Animal#initialize` method was never executed
- uninitialized instance variables return `nil`
- in order to have an instance variable accessible from a `module`, you must invoke the method where it was initialized

```ruby
module Swim
  def enable_swimming
    @can_swim = true
  end
end

class Dog
  include Swim

  def swim
    "swimming!" if @can_swim
  end
end

teddy = Dog.new
teddy.swim                                  # => nil
```

```ruby
teddy.enable_swimming
teddy.swim                                  # => swimming!
```

## Class Variables:

- **Class Variables** have a very insidious behavior of allowing sub-classes to override super-class class variables. Further, the change will affect all other sub-classes of the super-class. This is extremely unintuitive behavior, forcing some Rubyists to eschew using class variables altogether.

```ruby
class Animal
  @@total_animals = 0

  def initialize
    @@total_animals += 1
  end
end

class Dog < Animal
  def total_animals
    @@total_animals
  end
end

spike = Dog.new
spike.total_animals                           # => 1
```

- in this example it appears that class variables are accessible to sub-classes.

```ruby
class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

Vehicle.wheels                              # => 4
```

```ruby
class Motorcycle < Vehicle
  @@wheels = 2
end

Motorcycle.wheels                           # => 2
Vehicle.wheels                              # => 2  Yikes!
```

- because theres only 1 copy of a class variable across all sub-classes 
- it can permanently alter the object that the initial class was pointing to through reassignment!

```ruby
class Car < Vehicle
end

Car.wheels                                  # => 2  Not what we expected!
```

- even when instantiating a new class `Car` subclassed from `Vehicle` to avoid the change we made in `Motocycle` - the change is still present
- The fact that an entirely different sub-class of `Vehicle` can somehow modify this class variable throws a wrench into the way we think about class inheritance.
- For this reason, avoid using class variables when working with inheritance
-  The solution is usually to use *class instance variables*

## Constants:

- **Constants** have *lexical scope* which makes their scope resolution rules very unique compared to other variable types. If Ruby doesn't find the constant using lexical scope, it'll then look at the inheritance hierarchy.
- unlike class or instance variables we can actually find constants in the class it was initialized in and reference it
- using `::` we tell ruby where to find the constant <- known as the **"namespace resolution operator"**

```ruby
class Dog
  LEGS = 4
end

class Cat
  def legs
    Dog::LEGS                               # added the :: namespace resolution operator
  end
end

kitty = Cat.new
kitty.legs                                  # => 4
```

- when it comes to inheritance, a constant initialized in a super-class is inherited by the sub-class and is accessible by both class and instance methods

```ruby
class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  def self.wheels
    WHEELS
  end

  def wheels
    WHEELS
  end
end

Car.wheels                                  # => 4

a_car = Car.new
a_car.wheels                                # => 4
```

- constants are not evaluated during runtime, so where they're used in the code (**lexical scope**) is very important. 
- In this case `WHEELS` is in the `maintenance` module and this is where ruby will look for it
- even when we call the `change_tires` method on `a_car` object ruby cannot find it

```ruby
module Maintenance
  def change_tires
    "Changing #{WHEELS} tires."
  end
end

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  include Maintenance
end

a_car = Car.new
a_car.change_tires                          # => NameError: uninitialized constant Maintenance::WHEELS
```

- The fix for this is:

```ruby
module Maintenance
  def change_tires
    "Changing #{Vehicle::WHEELS} tires."    # this fix works
  end
end
```

- or:

```ruby
module Maintenance
  def change_tires
    "Changing #{Car::WHEELS} tires."        # surprisingly, this also works
  end
end
```

- the second one works because `Car` class can access `Vehicle` class through inheritance
- resolving constants ruby will look at lexical scope first and then look at inheritance hierarchy.
- When there are nested modules it can get tricky each setting the same constants to different values 
- constant resolution rules are different to method lookup path/instance variables