# The Object Model

---

## Terminology

**OOP:**

- A programming paradigm created to deal with the growing complexity of large software systems. 
- One small change would trigger a ripple of errors due to dependencies throughout the program. 
- OOP is a way that data can be changed and manipulated without affecting the whole program. 
- It is the interaction of instead many small parts as opposed to a massive blob of dependency.

**Encapsulation:** 

- the hiding of pieces of functionality, making them unavailable to the rest of the code base. 
- A form of data protection so that data cannot be manipulated of changed without obvious intention.
- Ruby objects are strictly encapsulated: ie their state can be accessed only through the methods they define.
- Ruby does this by creating objects and exposing interfaces (methods) to interact with those objects.
- Ruby is strongly object oriented, however, and its objects are fully encapsulated; the only way to interact with them is by invoking their methods.

**Polymorphism:**

- the ability for different types of data to respond to a common interface (methods)
- EG if we have a method that expects argument objects that have an `move` method, we can pass it any type of argument, provided it has a compatible `move` method. 
- "Poly" stands for "many" and "morph" stands for "forms".

**Inheritance:**

- Where a class inherits the behavior of the superclass. 
- This gives programmers the power to define basic classes with large reusability and smaller classes for more fine-grained detailed behaviors.

**Module:**

- A module allows us to group reusable code into one place.
- a module is a collection of behaviors similar to a class except you cannot create objects with it. In order to be used they must be mixed in with a class using the include method. These are called mixins.
- After mixing in a module, the behaviors declared in that module are available to that class and its objects.
- another way to achieve polymorphism in Ruby

```ruby
module Speak
  def speak(sound)
    puts sound
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!")        # => Arf!
bob = HumanBeing.new
bob.speak("Hello!")         # => Hello!
```

- both the `GoodDog` object, which we're calling `sparky`, as well as the `HumanBeing` object, which we're calling `bob`, have access to the `speak` instance method via the `include` method invocation. This is possible through "mixing in" the module `Speak`. It's as if we copy-pasted the `speak` method into the `GoodDog` and `HumanBeing` classes.

**Objects:**

- Every value in ruby is (or at least behaves like) an object.

- Every object is an instance of some class.

- this includes numbers, strings, arrays, and even classes and modules. 

- There are a few things that are not objects: methods and blocks are two that stand out.

- objects are created from classes. Classes are like molds are objects are like the things that you produce out of these molds.

  ```ruby
  #two objects from the string class
  irb :001 > "hello".class #.class is an instance method
  => String
  irb :002 > "world".class
  => String
  ```

**Classes:**

- A class defines a set of methods that an object responds to
- Ruby defines the attributes and behaviors of its objects in classes. 
- classes are the basic outlines of what an object should be made up of and what it should be able to do.
- the `class` keyword creates a new constant to refer to the class
-  Inside the body of a class but outside of any instance methods defined by the class the `self` keyword refers to the class being defined
- classes can include or inherit methods from modules
- they can also extend or subclass other classes and inherit or override the methods from their superclass
- Use CamelCase naming to create the class name
- ruby files should be named with snake case and reflect the class name 
- `class` like `def` is an expression, in that the value of a `class` expression is the value of the last expression within the `class` body
  - typically the last expression within a class is a `def` statement, defining a method. the value of a `def` statement is always `nil`

```ruby
class GoodDog
end
#creating an instance of GoodDog class and stored it in the variable sparky
sparky = GoodDog.new #sparky is an object/instance of class GoodDog.
```

**Instantiation:**

- Creating a new object / instance from a class 
- Shown above, we've instantiated an object called `sparky` from the class `GoodDog`
- when we invoke the class method `.new`, the new object is returned 

![Class Instance Diagram](https://d2aw5xe2jldque.cloudfront.net/books/ruby/images/class_instance_diagram.jpg)

```ruby
class Point
end
# Even though there's nothing in class point we can still instatiate a point
p = Point.new
# the constant Point holds a class object that represents our new class
```

- all class objects have a method `new` that creates a new instance.

**Method Lookup:**

- Ruby knows how to find methods each time one is invoked by using a distinct lookup path that it follows.

  ```
  ---GoodDog ancestors---
  GoodDog
  Speak
  Object
  Kernel
  BasicObject
  
  ---HumanBeing ancestors---
  HumanBeing
  Speak
  Object
  Kernel
  BasicObject
  ```

- `Speak` module is placed right between our custom classes : `GoodDog` and `HumanBeing`

- Since the `Speak` method is not defined in the `GoodDog` class, the next place it looks is the `Speak` module

- It continues in an ordered linear fashion until the method is found or there are no more places to look