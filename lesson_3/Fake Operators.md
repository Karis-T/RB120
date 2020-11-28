#  Fake operators

---

- ruby is difficult for beginners due to liberal syntax.
- eg the equality operator `==` is a method made to look like an operator thanks to ruby's **syntactical sugar** upon method invocation.
- instead of calling the method `str1.==(str2)` , it can be called with syntax that reads more naturally: `str1 == str2` 
- here's a table that shows which operators are methods and which are real operators

| Method | Operator                                                     | Description                                                  |
| :----- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| yes    | `[]`, `[]=`                                                  | Collection element getter and setter.                        |
| yes    | `**`                                                         | Exponential operator                                         |
| yes    | `!`, `~`, `+`, `-`                                           | Not, complement, unary plus and minus (method names for the last two are +@ and -@) |
| yes    | `*`, `/`, `%`                                                | Multiply, divide, and modulo                                 |
| yes    | `+`, `-`                                                     | Plus, minus                                                  |
| yes    | `>>`, `<<`                                                   | Right and left shift                                         |
| yes    | `&`                                                          | Bitwise "and"                                                |
| yes    | `^`, `|`                                                     | Bitwise exclusive "or" and regular "or" (inclusive "or")     |
| yes    | `<=`, `<`, `>`, `>=`                                         | Less than/equal to, less than, greater than, greater than/equal to |
| yes    | `<=>`, `==`, `===`, `!=`, `=~`, `!~`                         | Equality and pattern matching (`!=` and `!~` cannot be directly defined) |
| no     | `&&`                                                         | Logical "and"                                                |
| no     | `||`                                                         | Logical "or"                                                 |
| no     | `..`, `...`                                                  | Inclusive range, exclusive range                             |
| no     | `? :`                                                        | Ternary if-then-else                                         |
| no     | `=`, `%=`, `/=`, `-=`, `+=`, `|=`, `&=`, `>>=`, `<<=`, `*=`, `&&=`, `||=`, `**=`, `{` | Assignment (and shortcuts) and block delimiter               |

- methods marked with `yes` are methods which we can define in our own classes to change their default behaviors
- This can be useful but since any class can provide their own fake methods eg `obj1 + obj2`  - it means we have no idea what will happen.

## Comparison Methods:

- gives us a nice syntax for comparing objects:

```ruby
class Person
  attr_accessor :name, :age
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def >(other_person)
    age > other_person.age
  end
end

bob = Person.new("Bob", 49)
kim = Person.new("Kim", 33)

puts "bob is older than kim" if bob > kim
# => "bob is older"
```

- if you don't specify a method for the person class we'll get a `NoMethodError`. Ruby can't find the `>` method for `bob`

- Note that defining `>` doesn't automatically give us `<`

## the `<<` and `>>` methods:

-  it's not common to implement `>>`
-  `>>` provides very clean code
- choose functionality that makes sense when implementing fake operators
- use `<<` method when working with a class that represents a collection

```ruby
class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    return if person.not_yet_18?  # suppose we had Person#not_yet_18?
    members.push person
  end
end

cowboys = Team.new("Dallas Cowboys")
emmitt = Person.new("Emmitt Smith", 46) 	# Person class from earlier

cowboys << emmitt                         # will this work?

cowboys.members                           # => [#<Person:0x007fe08c209530>]
```

## The plus method:

```ruby
1 + 1                                       # => 2
1.+(1)                                      # => 2
```

- in the above example the `+` is an `Integer` instance method
- `Integer#+`: increments the value by value of the argument, returning a new integer
- `String#+`: concatenates with argument, returning a new string
- `Array#+`: concatenates with argument, returning a new array
- `Date#+`: increments the date in days by value of the argument, returning a new date
-  The functionality of the `+` should be either incrementing or concatenation with the argument
- it's probably a good idea to follow the general usage of the standard libraries.

```ruby
class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    members.push person
  end

  def +(other_team)
    members + other_team.members
  end
end

# we'll use the same Person class from earlier

cowboys = Team.new("Dallas Cowboys")
cowboys << Person.new("Troy Aikman", 48)
cowboys << Person.new("Emmitt Smith", 46)
cowboys << Person.new("Michael Irvin", 49)


niners = Team.new("San Francisco 49ers")
niners << Person.new("Joe Montana", 59)
niners << Person.new("Jerry Rice", 52)
niners << Person.new("Deion Sanders", 47)
```

- Our `Team#+` method should return a new `Team` object.  but right now it returns an array of person objects
- to remedy this we do:

```ruby
class Team
  # ... rest of class omitted for brevity

  def +(other_team)
    temp_team = Team.new("Temporary Team")
    temp_team.members = members + other_team.members
    temp_team
  end
end

dream_team = niners + cowboys
puts dream_team.inspect                     # => #<Team:0x007fac3b9eb878 @name="Temporary Team" ...
```

## Element setter and getter methods:

- of all the fake operators, perhaps `[]` and `[]=` are the most surprising.
- element reference

```ruby
my_array = %w(first second third fourth)    # ["first", "second", "third", "fourth"]

# element reference
my_array[2]                                 # => "third"
my_array.[](2)                              # => "third"
```

- element assignment:

```ruby
# element assignment
my_array[4] = "fifth"
puts my_array.inspect   # => ["first", "second", "third", "fourth", "fifth"]

my_array.[]=(5, "sixth")
puts my_array.inspect # => ["first", "second", "third", "fourth", "fifth", "sixth"]
```

-  `my_array[4] = "fifth"` syntax reads much more naturally
- this syntax manipulation is also why sometimes it's hard to understand where certain code comes from.
- if you want to make getter and setter methods, make sure its a class that represents a collection

```ruby
class Team
  # ... rest of code omitted for brevity

  def [](idx)
    members[idx]
  end

  def []=(idx, obj)
    members[idx] = obj
  end
end

# assume set up from earlier
cowboys.members                           # => ... array of 3 Person objects

cowboys[1]                                # => #<Person:0x007fae9295d830 @name="Emmitt Smith", @age=46>
cowboys[3] = Person.new("JJ", 72)
cowboys[3]                                # => #<Person:0x007fae9220fa88 @name="JJ", @age=72>
```

