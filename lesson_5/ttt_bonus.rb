# board class
require "pry"
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  def initialize
    @squares = {}
    1.upto(9) { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts ""
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
    puts ""
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    line_win = WINNING_LINES.select { |arr| arr if three_alike_markers?(arr) }
    line_win.empty? ? nil : @squares[line_win[0][0]].marker
  end

  def reset
    initialize
  end

  def find_ai_move(mark)
    ai_move = WINNING_LINES.select do |arr|
      convert_to_square(arr).count(mark) == 2 &&
        convert_to_square(arr).count(Square::INITIAL_MARKER) == 1
    end.first
    ai_move ? match_move(ai_move) : nil
  end

  private

  def match_move(ai_move)
    unmarked_keys.select { |num| ai_move.include?(num) }.first
  end

  def convert_to_square(arr)
    arr.map { |key| @squares[key].marker }
  end

  def three_alike_markers?(arr)
    sample_marker = @squares[arr.sample].marker
    arr.all? do |key|
      @squares[key].marker == sample_marker && @squares[key].marked?
    end
  end
end

# square class
class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

# player class
class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

# scoring class
class ScoreBoard
  ROUNDS = 3

  def initialize
    @scoreboard = { "human" => 0, "computer" => 0 }
  end

  def update(player)
    @scoreboard[player] += 1
  end

  def num(player)
    @scoreboard[player]
  end

  def grand_winner?
    @scoreboard.values.include?(ROUNDS)
  end

  def detect_grand_winner
    return unless grand_winner?
    puts "\nGrand winner is..."
    num("human") == ROUNDS ? puts("You!!") : puts("Computer!!")
    reset_score
  end

  def reset_score
    initialize
  end
end

# game orchestration engine
class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer, :scoreboard

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @scoreboard = ScoreBoard.new
    @current_turn = 1
  end

  def play
    clear
    display_welcome_message
    who_goes_first?
    main_game
    display_goodbye_message
  end

  private

  def who_goes_first?
    @answer = nil
    loop do
      puts "Would you like to go first? (y, n, choose)"
      @answer = gets.chomp
      break if %w(y n choose).include?(@answer)
      puts "Sorry, that's not a valid choice."
    end
    detect_turn_order
  end

  def detect_turn_order
    case @answer
    when 'y' then @current_turn = 1
    when 'n' then @current_turn = 2
    else
      @current_turn = [1, 2].sample
    end
  end

  def player_move
    loop do
      current_player_turn
      break if board.someone_won? || board.full?

      clear_screen_and_display_board
      @current_turn += 1
    end
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      display_score
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts "The player who wins #{ScoreBoard::ROUNDS} rounds is the grand winner!"
    puts "\n"
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    board.draw
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(arr)
    arr.length == 1 ? arr[0] : "#{arr[0..-2].join(', ')} or #{arr[-1]}"
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def offensive_move
    board.find_ai_move(computer.marker)
  end

  def defensive_move
    board.find_ai_move(human.marker)
  end

  def computer_moves
    computer_marker = computer.marker
    if board.unmarked_keys.include?(5)
      board[5] = computer_marker
    elsif offensive_move
      board[offensive_move] = computer_marker
    elsif defensive_move
      board[defensive_move] = computer_marker
    else
      board[board.unmarked_keys.sample] = computer_marker
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts 'You won!'
    when computer.marker
      puts 'Computer won!'
    else
      puts "It's a tie!"
    end
    tally_score
  end

  def tally_score
    scoreboard.update("human") if human.marker == board.winning_marker
    scoreboard.update("computer") if computer.marker == board.winning_marker
  end

  def display_score
    puts "\nCurrent total scores are:"
    puts "\nYou: #{scoreboard.num('human')}"
    puts "Computer: #{scoreboard.num('computer')}"
    scoreboard.detect_grand_winner
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts 'Sorry, must be y or n'
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    clear
    detect_turn_order
  end

  def display_play_again_message
    puts "Let's play again!"
  end

  def current_player_turn
    @current_turn.odd? ? human_moves : computer_moves
  end
end

game = TTTGame.new
game.play
