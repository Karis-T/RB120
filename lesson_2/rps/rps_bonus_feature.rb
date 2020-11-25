def prompt(message)
  Kernel.puts("=> #{message}")
end

module Stringable
  def to_s
    @val.to_s
  end
end

class Rock
  include Stringable
  def initialize
    @val = "rock"
  end
end

class Paper
  include Stringable
  def initialize
    @val = "paper"
  end
end

class Scissors
  include Stringable
  def initialize
    @val = "scissors"
  end
end

class Lizard
  include Stringable
  def initialize
    @val = "lizard"
  end
end

class Spock
  include Stringable
  def initialize
    @val = "spock"
  end
end

class Move
  WINNING_COMBOS = {
    'rock' => ['lizard', 'scissors'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['spock', 'paper'],
    'spock' => ['scissors', 'rock']
  }

  attr_accessor :value

  def initialize(value)
    arr = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new]
    @value = arr.select { |object| object.to_s == value }.first.to_s
  end

  def >(other_move)
    WINNING_COMBOS[@value].include?(other_move.value)
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
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
      prompt "Choose rock, paper, scissors, lizard or spock:"
      choice = gets.chomp
      break if Move::WINNING_COMBOS.keys.include?(choice)
      prompt "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Chappie", "Sonny", "Number 5"].sample
  end

  def choose
    comp_move = nil
    case name
    when "R2D2" then comp_move = ['spock', 'rock'].sample
    when "Hal" then comp_move = 'scissors'
    when "Sonny" then comp_move = ['paper', 'lizard'].sample
    when "Chappie" then comp_move = Move::WINNING_COMBOS.keys.sample
    when "Number 5" then comp_move = ['rock', 'paper', 'scissors'].sample
    end
    self.move = Move.new(comp_move)
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
    human_value = human.move.value
    computer_value = computer.move.value
    puts "#{human.name} chose #{human_value}"
    puts "#{computer.name} chose #{computer_value}"
    track_moves(human_value, computer_value)
  end

  def display_winner
    human_move = human.move
    computer_move = computer.move
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
    scoreboard.update("human") if human.move > computer.move
    scoreboard.update("computer") if computer.move > human.move
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
