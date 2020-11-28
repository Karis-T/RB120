module Promptable
  def prompt(message)
    Kernel.puts("=> #{message}")
  end
end

class Move
  VALUES = ["rock", "paper", "scissors", "lizard", "spock"]
  attr_reader :choice

  def initialize(value)
    arr = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new]
    @choice = arr.select { |object| object.to_s == value }.first
  end

  def >(other_move)
    win.include?(other_move.to_s)
  end

  def to_s
    val
  end
end

class Rock < Move
  attr_reader :val, :win

  def initialize
    @val = "rock"
    @win = ['lizard', 'scissors']
  end
end

class Paper < Move
  attr_reader :val, :win

  def initialize
    @val = "paper"
    @win = ['rock', 'spock']
  end
end

class Scissors < Move
  attr_reader :val, :win

  def initialize
    @val = "scissors"
    @win = ['paper', 'lizard']
  end
end

class Lizard < Move
  attr_reader :val, :win

  def initialize
    @val = "lizard"
    @win = ['spock', 'paper']
  end
end

class Spock < Move
  attr_reader :val, :win

  def initialize
    @val = "spock"
    @win = ['scissors', 'rock']
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  include Promptable
  def set_name
    system "clear"
    n = ""
    loop do
      prompt "Whats your name?"
      n = gets.chomp
      break unless n.empty?
      prompt "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      prompt "Choose (r)ock, (p)aper, (sc)issors, (l)izard or (sp)ock:"
      choice = gets.chomp
      break if ['r', 'p', 'sc', 'l', 'sp'].include?(choice)
      prompt "Sorry, invalid choice."
    end
    selection = Move::VALUES.select { |word| word.start_with?(choice) }.first
    self.move = Move.new(selection)
  end
end

class Computer < Player
  attr_reader :robot

  def initialize
    @robot = [R2d2.new, Hal.new, Sonny.new, Number5.new, Chappie.new].sample
    super
  end

  def set_name
    self.name = robot.name
  end

  def choose
    self.move = Move.new(robot.preference.sample)
  end
end

class R2d2 < Computer
  attr_reader :name, :preference

  def initialize
    @name = "R2D2"
    @preference = ['spock', 'rock', 'lizard']
  end
end

class Hal < Computer
  attr_reader :name, :preference

  def initialize
    @name = "Hal"
    @preference = ["scissors"]
  end
end

class Chappie < Computer
  attr_reader :name, :preference

  def initialize
    @name = "Chappie"
    @preference = Move::VALUES.sample
  end
end

class Sonny < Computer
  attr_reader :name, :preference

  def initialize
    @name = "Sonny"
    @preference = ['paper', 'lizard', 'rock']
  end
end

class Number5 < Computer
  attr_reader :name, :preference

  def initialize
    @name = "Number 5"
    @preference = ['rock', 'paper', 'scissors']
  end
end

class Board
  def initialize
    @board = { "human" => 0, "computer" => 0 }
  end

  def update(player)
    @board[player] += 1
  end

  def num(player)
    @board[player]
  end

  def grand_winner?
    @board.values.include?(3)
  end

  def reset_game
    initialize
  end
end

# game orchestration engine
class RPSgame
  include Promptable
  @@human_moves = []
  @@computer_moves = []
  attr_accessor :human, :computer, :scoreboard

  def initialize
    @human = Human.new
    @computer = Computer.new
    @scoreboard = Board.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "\nThe player who wins 3 rounds is the grand winner!"
  end

  def track_moves(hum_value, comp_value)
    @@computer_moves << comp_value
    @@human_moves << hum_value
  end

  def display_moves
    human_value = human.move.choice
    computer_value = computer.move.choice
    puts "#{human.name} chose #{human_value}"
    puts "#{computer.name} chose #{computer_value}"
    track_moves(human_value, computer_value)
  end

  def display_winner
    human_move = human.move.choice
    computer_move = computer.move.choice
    if human_move > computer_move
      puts "\n#{human.name} won!"
    elsif computer_move > human_move
      puts "\n#{computer.name} won!"
    else
      puts "\nIt's a tie!"
    end
    tally_score
  end

  def tally_score
    human_move = human.move.choice
    computer_move = computer.move.choice
    scoreboard.update("human") if human_move > computer_move
    scoreboard.update("computer") if computer_move > human_move
  end

  def display_score
    puts "\nCurrent total scores are:"
    prompt "#{human.name}: #{scoreboard.num('human')}"
    prompt "#{computer.name}: #{scoreboard.num('computer')}"
    detect_grand_winner
  end

  def detect_grand_winner
    return unless scoreboard.grand_winner?
    puts "\nGrand winner is..."
    if scoreboard.num("human") == 3
      prompt "#{human.name}!!"
    else
      prompt "#{computer.name}!!"
    end
    scoreboard.reset_game
  end

  def display_goodbye_message
    prompt "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      prompt "Sorry must be y or n."
    end
    system "clear"
    answer == 'y'
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSgame.new.play
