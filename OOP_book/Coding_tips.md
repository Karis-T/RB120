# Coding Tips

---

## 1. before design, Explore the problem:

- take time to explore code with a **spike** - ie exploratory code to play around with the problem
- Spikes can help find initial hunches / hypotheses
- idea of spike is to throw away the code after your done with it
- spike is like a brain-dump for an essay
- Only when you start to understand the problem better and get a feel for possible solutions only then start organizing your code into coherent classes and methods

## 2. if you keep repeating nouns in method names, its a sign you're missing a class

```ruby
human.make_move
computer.make_move

puts "Human move was #{format_move(human.move)}."
puts "Computer move was #{format_move(computer.move)}."

if compare_moves(human.move, computer.move) > 1
  puts "Human won!"
elsif compare_moves(human.move, computer.move) < 1
  puts "Computer won!"
else
  puts "It's a tie!"
end
```

- All the references to "move" gives us a hint that we should be encapsulating the move into a custom move object, so that we can tell the object to "format yourself" or "compare yourself against another". Look at how the code could be possibly improved:

```ruby
human.move!
computer.move!

puts "Human move was #{human.move.display}."
puts "Computer move was #{computer.move.display}."

if human.move > computer.move
  puts "Human won!"
elsif human.move < computer.move
  puts "Computer won!"
else
  puts "It's a tie!"
end
```

## 3. don't include the class name when naming methods

```ruby
class Player
  def player_info
    # returns player's name, move and other data
  end
end

player1 = Player.new
player2 = Player.new

puts player1.player_info
puts player2.player_info
```

- in this case calling the method `info` reads much better when invoking instance methods

```ruby
puts player1.info
puts player2.info
```

- pick names that are:
  - consistent
  - easy to remember
  - give an idea what the method does
  - reads well on invocation

## 4. Avoid long method invocations

```ruby
human.move.display.size
```

- When working with object oriented code, it's tempting to keep calling methods on collaborator objects

- it's very hard to debug the error with a 3 chain method invocation for example. If `human.move` returns `nil`, then the entire method invocation chain blows up. 

-  develop the initial instinct to smell out code that contains long method invocation chains

- try to think about the possibility of `nil` or other unexpected return values in the middle of the chain.

-  If you've identified that `human.move` could possibly return `nil`, for example, then you can put in some guard expressions like this:

  ```ruby
  move = human.move
  puts move.display.size if move
  ```

## 5. Avoid design patterns for now

- mis-application of "best practices" or "design patterns" to improve performance or flexibility. 
- This is such a common phenomenon that experienced programmers have a quote: "premature optimization is the root of all evil".
- Don't worry about optimization at this point. Don't write overly clever code.
- Most importantly, you should spend time understanding *when* to use best practices.