# Inheritance

---

- when a class inherits behaviors from another class
- the class inheriting the behavior is called the subclass (child)
- the class it inherits from is called the superclass (parent)
- we use inheritance for the purposes of extracting common behaviors from classes that share that behavior and more it to a superclass. 
- it helps us keep logic in 1 place, remove duplications in your codebase
- "DRY" don't repeat yourself, extract the logic to one place for reuse

```ruby
# 1. extracting speak to a superclass Animal 
# 2. then use inheritance to make that behaviour available to GoodDog and Cat classes

class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
end

class Cat < Animal
end

sparky = GoodDog.new
paws = Cat.new
puts sparky.speak           # => Hello!
puts paws.speak             # => Hello!
```

- use the `<` symbol to signify that the `GoodDog` class is inheriting from the `Animal` class
- this means that all the methods from the `Animal` class are available to the `GoodDog` class for use
- you can override superclass (parent) methods with subclass (child) methods because ruby checks the object's class first before it looks at the superclass

```ruby
class Animal
  def speak 							# this method was overridden
    "Hello!"
  end
end

class GoodDog < Animal
  attr_accessor :name

  def initialize(n)
    self.name = n
  end

  def speak 							# this method was used instead of Animal speak 
    "#{self.name} says arf!"
  end
end

class Cat < Animal
end

sparky = GoodDog.new("Sparky")
paws = Cat.new

puts sparky.speak           # => Sparky says arf! (looks at sparky's class GoodDog first and used the speak method)
puts paws.speak             # => Hello! (looked at paws class and found nothing but did find it in the superclass Animal)
```

## Super:

- a built in method that invokes method earlier in the lookup path
- when you invoke `super` from within a method it will search the method lookup path for a method with the same name, then invoke it.

```ruby
class Animal
  def speak
    "Hello!" # this code is executed because the method has the same name
  end
end

class GoodDog < Animal
  def speak
    super + " from GoodDog class"
  end
end

sparky = GoodDog.new
sparky.speak        # => "Hello! from GoodDog class"
```

```ruby
class Animal
  attr_accessor :name

  def initialize(name)
    @name = name								# uses brown as name
  end
end

class GoodDog < Animal
  def initialize(color)
    super												# passes on "brown to superclass"
    @color = color							 # continues to execute brown as color
  end
end

bruno = GoodDog.new("brown")        # => #<GoodDog:0x007fb40b1e6718 @color="brown", @name="brown">
```

- when you use super within the initialize method it passes on the argument ("brown") to the superclass and uses it in that method too

```ruby
class BadDog < Animal
  def initialize(age, name)
    super(name)
    @age = age
  end
end

BadDog.new(2, "bear")        # => #<BadDog:0x007fb40b2beb68 @age=2, @name="bear">
```

- in this example super takes an argument and passes it to the superclass version of the method

```ruby
class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super()
    @color = color
  end
end

bear = Bear.new("black")        # => #<Bear:0x007fb40b1e6718 @color="black">
```

- in this final answer if you invoke `super` with empty parentheses `()` it calls the method in the superclass that doesn't take arguments. If you forget to use parentheses it'll raise an ArgumentError, because the number of arguments is incorrect.

## Mixing in Modules:

- superclass is for:
  - extracting common methods to a superclass that's naturally hierarchal
  - putting the right behavior in the right class so we don't need to repeat code in multiple classes 

- modules are for :
  - mixing in methods that only certain types of classes (not all) need 
  -  falls out of the natural hierarchal structure
  - so we don't need to repeat the same methods for different classes

```ruby
module Swimmable
  def swim
    "I'm swimming!"
  end
end

class Animal; end

class Fish < Animal
  include Swimmable         # mixing in Swimmable module (fish swim)
end

class Mammal < Animal 			# not all mammals swim 
end

class Cat < Mammal					# cats don't swim	
end

class Dog < Mammal
  include Swimmable         # mixing in Swimmable module (dogs swim)
end
```

- module naming convention: attach "able" to the verb that the method performs- ie `swim` becomes `swimmable`. `walking` becomes `walkable`

## Inheritance vs Modules:

- 2 types of Ruby inheritance:
  1. Class inheritance: where one class inherits the behaviors of another superclass
  2. Interface inheritance: where one class inherits the interface provided by the mixin module
- When to use superclass? When to use mixins?
  - you can only create 1 superclass to subclass link (1 inheritance) one parent, one child
  - whereas you can mix in as many modules (interface inheritance) as you like
  - if there is an "is-a?" relationship class inheritance is usually the way to go.
  - if there is an "has-a?"  relationship interface inheritance is the way to go. eg dog is-an animal and has-an ability to swim
  - You cannot instantiate modules (cant create objects with modules). Modules are only for namespacing and grouping common methods together

## Method Lookup Path:

```
---GoodDog method lookup---
GoodDog
Climbable
Swimmable
Animal
Walkable
Object
Kernel
BasicObject
```

- the order in which classes are inspected when you invoke a method
- the order in which we include modules is important. 
  - ruby looks at the last module that was included FIRST
  - the rare times modules methods have the same name as other module methods, Ruby will consult the first module that was included
- ruby includes the superclass modules in a lookup too
  - this means `GoodDog` will have access to superclass `Animal`'s `Walkable` module

## More Modules:

- namespacing: organizing similar classes under a module - modules to group related classes
- Advantages:
  - this allows us to recognize related classes
  - reduces the likelihood of our classes colliding with other similarly named classes in our codebase
- to call classes from a module append 2 colons the module followed by the class

```ruby
module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end
end

buddy = Mammal::Dog.new 		  #call the class Dog from the module Mammal
kitty = Mammal::Cat.new			  #call the class Cat from the module Mammal
buddy.speak('Arf!')           # => "Arf!"
kitty.say_name('kitty')       # => "kitty"
```

- module methods: use modules to house other methods that seem out of place with your code

```ruby
module Mammal
  def self.some_out_of_place_method(num)
    num ** 2
  end
end
#call either directly from the module (preferred)
value = Mammal.some_out_of_place_method(4)
#or by ::
value = Mammal::some_out_of_place_method(4)
```

## Private, Protected and Public:

- **Method access control**: using access modifiers to allow or restrict access to a particular method(s) in a class 
- Access modifiers in ruby:
  - **public** method (default): a method available to anyone who knows either class name or object name. Available to the program to use
  - **private** method: doing work in the class but don't need to be available to the rest of the program. Only accessible to other methods in the class
  - **protected** method: 
    - from inside a class, `protected` methods are accessible like a `public` method
    - from outside a class, `protected` methods are just like a `private` method

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name=(n)
    self.age=(a)
  end
  
  def public_disclosure
  "#{self.name} in human years is #{human_years}" 
   #cannot use self.human_years == sparky.human_years (not allowed for private methods) human_years is acceptable
	end

  private

  def human_years
    age * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
sparky.human_years
```

```ruby
class Animal
  def a_public_method
    "Will this work? " + self.a_protected_method #called inside the class
  end

  protected
  def a_protected_method
    "Yes, I'm protected!"
  end
end

fido = Animal.new
fido.a_public_method        # => Will this work? Yes, I'm protected!

fido.a_protected_method			# called outside the class
#=> NoMethodError: protected method `a_protected_method' called for
    #<Animal:0x007fb174157110>
```



## Accidental Method Overriding:

- every class you create becomes a subclass to the original class `Object`. 
- The `Object` class comes with many important methods. 
  - a subclass can override a superclass' method
  - if you accidentally override a method originally defined in the `Object` class it can have far reaching effects on your code. 
  - familiarize yourself with object methods so you don't accidentally override them







