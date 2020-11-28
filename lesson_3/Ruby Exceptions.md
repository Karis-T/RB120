# Ruby exceptions

---

## What is an Exception?:

- an exception is an exceptional state in your code
- its ruby's way of letter you know that your code is behaving unexpectedly
- if an exception is raised and the code cannot handle the exception, the program crashes and ruby provides a message telling you want kind of error you encountered

```ruby
3 + "z"
# Program execution stops
#=> String can't be coerced into Integer (TypeError)
```

- Ruby provides a hierarchy of built-in classes to simplify exception handling
- the names you see when a program crashes are the class names eg `TypeError`
- the class at the top of the hierarchy is the `Exception` class.
- `Exception` has several subclasses which have descendants of their own

## The exception class hierarchy:

```ruby
Exception
  NoMemoryError
  ScriptError
    LoadError
    NotImplementedError
    SyntaxError
  SecurityError
  SignalException
    Interrupt
  StandardError
    ArgumentError
      UncaughtThrowError
    EncodingError
    FiberError
    IOError
      EOFError
    IndexError
      KeyError
      StopIteration
    LocalJumpError
    NameError
      NoMethodError
    RangeError
      FloatDomainError
    RegexpError
    RuntimeError
    SystemCallError
      Errno::*
    ThreadError
    TypeError
    ZeroDivisionError
  SystemExit
  SystemStackError
  fatal
```

- pressing `ctrl + c` exits out of a program and raises the `Interrupt` class
- executed code with invalid syntax raises the `SyntaxError`
- recursive infinite loops causes a stack overflow and raises the `SystemStackError`
- `StandardError` has descendants such as `ArgumentError`, `TypeError`, `ZeroDivisionError`, and `NoMethodError` are all common exceptions that are children or grandchildren of the `StandardError` class.

## When should you handle an exception?:

- The errors you want to handle are descendants from the `StandardError` class.
- Exceptions are usually caused by:
  - unexpected user input
  - faulty type conversions
  - dividing zero
- its dangerous to handle all exceptions as some are more serious than others - ie there are some errors we should allow to crash our program
- eg `NoMemoryError`, `SyntaxError`, and `LoadError` must be addressed in order for our program to operate appropriately.
- if you handle all exceptions it may result in masking critical errors and make debugging a very difficult task

## How to handle an Exception:

### begin/rescue block:

- this block handles errors that can keep your program from crashing if the exception you have specified is raised

 ```ruby
begin
  # put code at risk of failing here
rescue TypeError
  # take action
end
 ```

- The above example will execute the code in the `rescue` clause rather than exiting the program if the code on line 2 raises a `TypeError`. 
- If no exception is raised, the `rescue` clause will not be executed at all and the program will continue to run normally. 
- You can see that on line 3 we specified what type of exception to rescue. 
- If no exception type is specified, all `StandardError` exceptions will be rescued and handled. 
- Remember *not* to tell Ruby to rescue `Exception` class exceptions. 
- you can rescue multiple exceptions to handle different types of errors 

```ruby
begin
  # some code at risk of failing
rescue TypeError
  # take action
rescue ArgumentError
  # take a different action
end
```

```ruby
begin
  # some code at risk of failing
rescue ZeroDivisionError, TypeError
  # take action
end
```

### Exception objects and Built-in Methods:

- Normal ruby objects that have built-in behaviors that can be used for debugging or exception handling

```ruby
rescue TypeError => e
```

- the code above rescues any type error and stores the exception object in `e`
- `Exception#message` and `Exception#backtrace` are useful instance methods 
- `#message` returns an error message 
- `#backtrace` returns a back trace associated with the exception

```ruby
begin
  # code at risk of failing here
rescue StandardError => e   # storing the exception object in e
  puts e.message            # output error message
end
```

- The code above rescues any type of `StandardError` exception (including all of its descendents) and output the message associated with the exception object. 
- this can be useful when debugging and need to find the type/cause of the error.
- never rescue the `Exception` class.

```ruby
e.class
#=> TypeError
```

- we can even call `Object#class` on an exception object to return its class name.

### Ensure:

- can be used after the last `rescue` clause
- This branch will always execute whether an exception was raised or not

```ruby
file = open(file_name, 'w')

begin
  # do something with file
rescue
  # handle exception
rescue
  # handle a different exception
ensure
  file.close
  # executes every time
end
```

- A simple example is resource management when working with a file, whether or not an exception was raised, this code ensures that it will always be closed
- The `ensure` clause serves as a single exit point for the block and allows you to put all of your cleanup code in one place
- It is critical that this code does not raise an exception itself. If the code within the `ensure` clause raises an exception, any exception raised in the `begin`/`rescue` block will be masked and debugging can become very difficult.

### Retry:

- not used very often
- Using `retry` in your `begin`/`rescue` block redirects your program back to the `begin` statement
- This allows your program to make another attempt to execute the code that raised an exception.
- You may find `retry` useful when connecting to a remote server
- if your code continually fails, you risk ending up in an infinite loop
-  it’s a good idea to set a limit on the number of times you want `retry` to execute

```ruby
RETRY_LIMIT = 5

begin
  attempts = attempts || 0
  # do something
rescue
  attempts += 1
  retry if attempts < RETRY_LIMIT
end
```

## Raising Exceptions Manually:

- *Handling* an exception is a reaction to an exception that has already been *raised*.
- You can manually raise exceptions by calling [Kernel#raise](https://ruby-doc.org/core-2.4.1/Kernel.html#method-i-raise). 
- This allows you to pick what type of exception to raise and sets your own error message. 
- If you do not specify what type of exception to raise, Ruby defaults to `RuntimeError` (a subclass of `StandardError`). 

```ruby
raise TypeError.new("Something went wrong!")
```

```ruby
raise TypeError, "Something went wrong!"
```

- exception types default to a `RuntimeError` when nothing is specified. The error message specified is `"invalid age"`.

```ruby
def validate_age(age)  
	raise("invalid age") 
	unless (0..105).include?(age) 
end 
```

- exceptions you raise manually in your program can be handled in the same manner as automatic exceptions.

```ruby
begin  
	validate_age(age) 
rescue RuntimeError => e  
	puts e.message              #=> "invalid age" 
end 
```

- here we placed the `validate_age` method in a `begin`/`rescue` block. 
- If an invalid age is passed in to the method, a `RuntimeError` with the error message `"invalid age"` will be raised  and the `rescue` clause of our `begin`/`rescue` block will be executed.

## Raising Custom Exceptions:

-  You can also create our own custom exception classes.

```ruby
class ValidateAgeError < StandardError; end 
```

- Notice that our custom exception class `ValidateAgeError` is a subclass of an existing exception. 
- `ValidateAgeError` has access to all of the built-in exception object behaviors, including `Exception#message` and `Exception#backtrace`. 
- avoid masking exceptions from the `Exception` class itself and other system-level exception classes. 
- Most often you will want to inherit from `StandardError`.
- you can be specific about the error your program encountered by giving the class a very descriptive name. 

```ruby
def validate_age(age)  
	raise ValidateAgeError, "invalid age" unless (0..105).include?(age) 
end

begin
	validate_age(age)
rescue ValidateAgeError => e
	# take action 
end 
```