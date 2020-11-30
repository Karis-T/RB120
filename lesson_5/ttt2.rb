# board class
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

  private

  def three_alike_markers?(arr)
    sample_marker = @squares[arr.sample].marker
    arr.all? do |num|
      @squares[num].marker == sample_marker && @squares[num].marked?
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

# game orchestration engine
class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_turn = 1
  end

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

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
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
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

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
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
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
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
