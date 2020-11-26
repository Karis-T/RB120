# Collaborator Objects

---

- Classes group common behaviours (methods)
- Objects encapsulate state and an objects state is saved in an instance variable
- Instance methods can operate on instance variables
- Usually the state is a string or number, but it can also hold data structures

```ruby
class Person
  def initialize
    @heroes = ['Superman', 'Spiderman', 'Batman']
    @cash = {'ones' => 12, 'fives' => 2, 'tens' => 0, 'twenties' => 2, 'hundreds' => 0}
  end

  def cash_on_hand
    # this method will use @cash to calculate total cash value
    # we'll skip the implementation
  end

  def heroes
    @heroes.join(', ')
  end
end

joe = Person.new
joe.cash_on_hand            # => "$62.00"
joe.heroes                  # => "Superman, Spiderman, Batman"
```

- the above example demonstrates we can use any object to represent an objects state - including data collections and even other objects

```ruby
class Person
  attr_accessor :name, :pet

  def initialize(name)
    @name = name
  end
end

bob = Person.new("Robert")
bud = Bulldog.new             # assume Bulldog class from previous assignment

bob.pet = bud
bob.pet                       # => #<Bulldog:0x007fd8399eb920>
bob.pet.class                 # => Bulldog
```

- `bob.pet` returns a `BullDog` object  - you can then use method chaining  

```ruby
bob.pet.speak                 # => "bark!"
bob.pet.fetch                 # => "fetching!"
```

- Objects that are stored as state within another object are also called **"collaborator objects".** This refers to an object that works in conjunction with the class theyre associated with.
- `bob` has a collaborator object stored in the `@pet` variable. When we need that `BullDog` object to perform some action (i.e. we want to access some behavior of `@pet`), then we can go through `bob` and call the method on the object stored in `@pet`, such as `speak` or `fetch`
- collaborator objects are usually custom made by the programmer
- Make sure to consider what collaborators your classes have and if those associations make sense, both technically from a problem solving point of view

```ruby
class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

bob = Person.new("Robert")

kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud

bob.pets   # => [#<Cat:0x007fd839999620>, #<Bulldog:0x007fd839994ff8>]
```

- to operate on an array of `Pet` objects you will have to iterate over the array

```ruby
bob.pets.each do |pet|
  pet.jump
end
```

- collaborator objects allow you to chop up and modularize the problem domain into cohesive pieces - they are at the core of OO programming and play an important role in modeling complicated problem domains.

## what is Collaboration?

- *Collaboration is a way of modeling relationships between different objects.*

  - **Inheritance** can be thought of as an *is-a* relationship.

  - **Association** can be thought of as a *has-a* relationship.

  - **Take away:** A collaborative relationship is a relationship of association — not inheritance. Collaboration is a *has-a* relationship rather than a *is-a* relationship.

1. First, collaborator objects can be of any type: custom class object, Array, Hash, String, Integer, etc. The class of object really depends on the program that you are designing
2. Second, a collaborator object is part of another object’s state. For example, by assigning a collaborator object to an instance variable in another class’ constructor method definition, you are associating the two objects with one another.
3. One way to spot them in code is when an object is assigned to an instance variable of another object inside a class definition.

**collaboration** occurs when one object is added to the state of another object (i.e., when a method is invoked on an object). However, a more helpful mental model is: *the collaborative relationship exists in the design (or intention) of our code.*