# Rock Paper Scissors OOP style

---

## Game Flow:

1. user makes a choice
2. computer makes a choice
3. winner is displayed

## OO Approach to Programming:

1.  Write a description of the problem/exercise
2. Extract the major nouns/verbs from description
3. Group verbs that associate with nouns
4. Nouns are classes and verbs are behaviours / methods

- in OOP we don't think about game flow logic at all. its all about organizing and modularizing code into classes / structure. 
- After we come up with the class definitions, the final step is to create the flow of the program using objects instantiated from classes.   

## RPS Description:

Rock, Paper, Scissors is a two-player game where each **player** <u>chooses</u>
one of three possible **moves**: rock, paper, or scissors. The chosen moves
will then be <u>compared</u> to see who wins, according to the following **rules**:

- rock beats scissors 
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

(rock paper scissor nouns ignored because they are variations/states of move)

## Organize Nouns and Verbs:

```
Player
 - choose
Move
Rule

- compare
```

## Initial Classes and Methods:

initial skeleton classes and methods

```ruby
class Player

  def initialize
    #name? and/or move?
  end

  def choose
  end

end

class Move
  def initialize
    #something to keep track of choices
    #move object could be paper, scissors, rock
  end
end

class Rule
  def initialize
    # don't know what state for rules
  end
end

# not sure where compare method goes just yet
def compare(move1, move2)
end
```

## Create an Engine:

- after creating the skeleton classes and methods an engine is needed to create the gameplay
- This is where the procedural program flow should be
- Engine class to be called `RPSGame`
- to play the game insatiate an object and call a method `play` 

```ruby
RPSGame.new.play
```

- what objects are needed in `play` method to create the game?

```ruby
class RPSGame
  def initialize
  end

  def play
    display_welcome_message
    human_choose_move #similar to line 8
    computer_choose_move #similar to line 7
    display_winner
    dispaly_goodbye_message
  end
end
```

- `human` and `computer` can both be objects of the `Player` class - which both can then have access to `Player#choose` method

```ruby
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end
```

- when it comes to OOP, there is no "absolute right" solution. In OOP its a matter of tradeoffs.
- There are absolute wrong approaches 
- OOP architecture is a topic in and of itself and will takes years/decades to master  