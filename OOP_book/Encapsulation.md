# Encapsulation

---

## Encapsulation:

1. only expose the methods and properties users of the objects need
2. hide the internal representation of the object from the outside
3. Method access control: using external interface (public methods) of a class

```ruby
class Dog
  attr_reader :nickname

  def initialize(n)
    @nickname = n
  end

  def change_nickname(n)
    self.nickname = n
  end

  def greeting
    "#{nickname.capitalize} says Woof Woof!"
  end

  private
    attr_writer :nickname
end

dog = Dog.new("rex")
dog.change_nickname("barny") # changed nickname to "barny"
puts dog.greeting # Displays: Barny says Woof Woof!
```

- the setter method is private and is unavailable outside the class
- but you can use instead the method change nickname which is available to the user
- you call the setter method with `self` as the caller
- as a convention its good to have as few a public methods as possible. It helps protect data from the outside world.