class Move
  VALUES = ["rock", "paper", "scissors"]

  def initialize(value)
    @value = value
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def >(other_move)
    if rock?
      other_move.scissors?
    elsif paper?
      other_move.rock?
    elsif scissors?
      other_move.paper?
    end
  end

  def to_s
    @value
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
    n = ""
    loop do
      puts "Whats your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Chappie", "Sonny", "Number 5"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Board
  def initialize
    @board = {"human" => 0, "computer" => 0}
  end

  def update(player)
    @board[player] += 1
  end

  def value(player)
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
  attr_accessor :human, :computer, :scoreboard

  def initialize
    @human = Human.new
    @computer = Computer.new
    @scoreboard = Board.new
  end

  def display_welcome_message
    puts "\nWelcome to Rock, Paper, Scissors!"
    puts "The player who wins 3 rounds is the grand winner!"
  end

  def display_moves
    puts "\n#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    human_move = human.move
    computer_move = computer.move
    if human_move > computer_move
      puts "\n#{human.name} won!"
      scoreboard.update("human")
    elsif computer_move > human_move
      puts "\n#{computer.name} won!"
      scoreboard.update("computer")
    else
      puts "\nIt's a tie!"
    end
  end

  def display_score
    puts "\nCurrent total scores are:"
    puts "#{human.name}: #{scoreboard.value("human")}"
    puts "#{computer.name}: #{scoreboard.value("computer")}"
  end

  def display_grand_winner
    if scoreboard.grand_winner?
      puts "\nGrand winner is..."
      if scoreboard.value("human") == 3
        puts "#{human.name}!!"
      else
        puts "#{computer.name}!!"
      end
      scoreboard.reset_game
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry must be y or n."
    end
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
      display_grand_winner
      break unless play_again?
      system "clear"
    end
    display_goodbye_message
  end
end

RPSgame.new.play
