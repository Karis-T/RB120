# Variable scope (instance, class & constants)

---

## Instance Variable Scope:

- start with an `@` 
- scoped at the **object** level
- used to track **individual object** states
- does not cross over between objects
-  instance variables are accessible to any of the object's instance methods, even if it's initialized outside of that instance method

```ruby
class Person
  def initialize(n)
    @name = n
  end

  def get_name
    @name                     # is the @name instance variable accessible here?
  end
end

bob = Person.new('bob')
bob.get_name                  # => "bob"
```

- if you try to access an instance variable that's not yet initialized anywhere it returns `nil`
- if you try the same with a local variable it returns a `NameError`

```ruby
class Person
  def get_name
    @name                     # the @name instance variable is not initialized anywhere
  end
end

bob = Person.new
bob.get_name                  # => nil
```

- if you try to put an instance variable at class level it registers as a **"class instance variable"**. 
- for now, Initialize instance variable within instance methods.

```ruby
class Person
  def get_name
    @name                     # the @name instance variable is not initialized anywhere
  end
end

bob = Person.new
bob.get_name                  # => nil
```

## Class Variable Scope:

- start with a `@@` 
- scoped at the class level
- all objects share only 1 copy of the class variable
- objects can interact with class variables via instance methods
- class methods can access class variables, regardless of where its initialized

```ruby
class Person
  @@total_people = 0            # initialized at the class level

  def self.total_people
    @@total_people              # accessible from class method
  end

  def initialize
    @@total_people += 1         # mutable from instance method
  end

  def total_people
    @@total_people              # accessible from instance method
  end
end

Person.total_people             # => 0
Person.new
Person.total_people             # => 1

bob = Person.new
bob.total_people                # => 2

Person.total_people             # => 2
```

## Constant Variable Scope:

- usually called constants
- You're not supposed to reassign them to a different value (Warning is raised)
- Begin with a capital letter
- has lexical scope: Available in both class and instance methods
- constant resolution gets tricky when inheritance is involved

