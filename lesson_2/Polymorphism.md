# Polymorphism

---

## Polymorphism: 

1. objects of different types, respond in different ways, to the same message / method invocation
2. different data types can respond to a common interface
3. when 2 or more object types have a method with the same name we can invoke that method with any of those objects.
4. polymorphism often involves inheritance from a common superclass but it isn't always necessary

**Polymorphism through inheritance:**

```ruby
class Animal
  def eat
    # generic eat method
  end
end

class Fish < Animal
  def eat
    # eating specific to fish
  end
end

class Cat < Animal
  def eat
     # eating specific to cat
  end
end

def feed_animal(object)
  object.eat
end

array_of_animals = [Animal.new, Fish.new, Cat.new]
array_of_animals.each do |object|
  feed_animal(object)
end
```

- the public interface lets us work with all of these types in the same way even though the implementations can be dramatically different. That is *polymorphism* in action.

**Polymorphism through Duck Typing:**

1. if it looks like a duck and quacks like a duck - then it's probably a duck
2. it doesn't concern itself with the class object, only with what method are available to that object.

```ruby
class Wedding
  attr_reader :guests, :flowers, :songs

  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_wedding(self)
    end
  end
end

class Chef
  def prepare_wedding(wedding)
    prepare_food(wedding.guests)
  end

  def prepare_food(guests)
    #implementation
  end
end

class Decorator
  def prepare_wedding(wedding)
    decorate_place(wedding.flowers)
  end

  def decorate_place(flowers)
    # implementation
  end
end

class Musician
  def prepare_wedding(wedding)
    prepare_performance(wedding.songs)
  end

  def prepare_performance(songs)
    #implementation
  end
end

[Chef.new, Decorator.new, Musician.new].prepare
```

- in this example there's no inheritance only polymorphism. Each class must define a `prepare_wedding` method and implement it in it's own way.
- if we need to add another preparer, we can just create a new class and implement `prepare_wedding` to perform their own action