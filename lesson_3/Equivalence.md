# Equivalence

---

- methods, blocks, if statements, argument lists, and other things are NOT objects

- when 2 objects hold the same value they are considered equal when using the "equality" `==` method:

```ruby
str1 = "something"
str2 = "something"
str1 == str2            # => true

int1 = 1
int2 = 1
int1 == int2            # => true

sym1 = :something
sym2 = :something
sym1 == sym2            # => true
```

- string objects come from the string class and if we modify one string and compare it to the original the value it holds is no longer equal so it would evaluate to `false`

```ruby
str1 = "something"
str2 = "something"

str1.class              # => String
str2.class              # => String

str1 = str1 + " else"
str1                    # => "something else"

str1 == str2            # => false
```

- `==` tests for if the values within the two objects are the same
- this is unlike the `equal` method which tests to see if 2 objects point to the exact same space in memory 

```ruby
str1 = "something"
str2 = "something"

# comparing the string objects' values
str1 == str2            # => true

# comparing the actual objects
str1.equal? str2        # => false
```

## the `==` method (common):

- for most objects, the `==` operator compares the values of the objects, and is frequently used.
- the `==` operator is actually a method. Most built-in Ruby classes, like `Array`, `String`, `Integer`, etc. provide their own `==` method to specify how to compare objects of those classes.
- by default, `BasicObject#==` does not perform an equality check; instead, it returns true if two objects are the same object. This is why other classes often provide their own behavior for `#==`.
- if you need to compare custom objects, you should define the `==` method.
- understanding how this method works is the most important part of this assignment.

- `==` is an instance method available to all objects in ruby.
- its the same as writing `str1.==(str2)` 
- its class determines what value to use for comparison. The original `==` method is defined by `BasicObject` which is the parent class for all classes in Ruby. 

```ruby
class Person
  attr_accessor :name
end

bob = Person.new
bob.name = "bob"

bob2 = Person.new
bob2.name = "bob"

bob == bob2                # => false

bob_copy = bob
bob == bob_copy            # => true
```

- the above implies that the default method for `==` is the same as `equal?`. 
- This isn't useful because we want to compare if two objects hold the same value instead of pointing to the same object
- each class should define the `==` method to specify what value to compare to.

```ruby
class Person
  attr_accessor :name

  def ==(other)
    name == other.name     # relying on String#== here
  end
end

bob = Person.new
bob.name = "bob"

bob2 = Person.new
bob2.name = "bob"

bob == bob2                # => true
```

- by defining the `==` method it overrides the original method from `BasicObject` which provides a much more meaningful way to compare 2 `Person` classes

```ruby
45 == 45.00   # => true	(Integer#== method) 
45.00 == 45		# => true	(Float#== method)
```

- here an integer is being compared to a float based on the `Integer==` method
- here it was possible to compare 2 classes together because of the way each method was defined to create a consistent interface
- when you define a `==` method you get the `!=` for free

## The `object_id` method (uncommon):

- every object has a method called `object_id` which returns a number value that uniquely identifies the object
- use this method to determine if there are 2 variables pointing to the same object.

```ruby
arr1 = [1, 2, 3]
arr2 = [1, 2, 3]
arr1.object_id == arr2.object_id      # => false

sym1 = :something
sym2 = :something
sym1.object_id == sym2.object_id      # => true

int1 = 5
int2 = 5
int1.object_id == int2.object_id      # => true
```

- symbols and integers aren't modifiable and will always take up the same space in memory
- this means it saves on memory (which is why programmers use it for hash keys instead of strings)

## The `equal?` method (uncommon):

- the `equal?` method goes one level deeper than `==` and determines whether two variables not only have the same value, but also whether they point to the same object.
- do not define `equal?`.
- the `equal?` method is not used very often.
- calling `object_id` on an object will return the object's unique numerical value. Comparing two objects' `object_id` has the same effect as comparing them with `equal?`.

## The `===` method (uncommon):

- an instance method used by the case statement
- used implicitly in `case` statements.
- like `==`, the `===` operator is actually a method.
- you rarely need to call this method explicitly, and only need to implement it in your custom classes if you anticipate your objects will be used in `case` statements, which is probably pretty rare.

```ruby
num = 25

if (1..50) === num
  puts "small number"
else
  puts "not in range"
end
```

```ruby
num = 25

case num
when 1..50
  puts "small number"
else
  puts "not in range"
end
```

- both code is the same and means: "does `25` belong to the group `(1..50)`?"

```ruby
String === "hello" # => true
String === 15      # => false
```

- line 1 refers to: "does `"hello"` belong to the group `String` class?"
- `===` is a very different operator in JavaScript. Do not get both confused with each other.

## the `eql?` method (uncommon):

- this method determines if two objects contain the same value && if they're of the same class. 
- used implicitly by `Hash`.
- very rarely used explicitly.