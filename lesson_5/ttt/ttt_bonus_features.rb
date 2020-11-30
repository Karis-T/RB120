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

  def find_ai_move(mark)
    ai_move = WINNING_LINES.select do |arr|
      convert_to_square(arr).count(mark) == 2 &&
        convert_to_square(arr).count(Square::INITIAL_MARKER) == 1
    end.first
    ai_move ? detect_empty_space(ai_move) : nil
  end

  private

  def detect_empty_space(ai_move)
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
  X_MARKER = 'X'
  O_MARKER = 'O'
  FIRST_PLAYER = 1
  SECOND_PLAYER = 2
  attr_reader :marker, :name

  def initialize
    @marker = nil
    @name = nil
    set_name
  end
end

class Computer < Player
  def assign_marker(answer)
    @marker = case answer
              when X_MARKER then O_MARKER
              when O_MARKER then X_MARKER
              end
  end

  def offensive_move(board)
    board.find_ai_move(marker)
  end

  def defensive_move(board, human)
    board.find_ai_move(human.marker)
  end

  def move(board, human)
    computer_marker = marker
    if board.unmarked_keys.include?(5)
      board[5] = computer_marker
    elsif offensive_move(board)
      board[offensive_move(board)] = computer_marker
    elsif defensive_move(board, human)
      board[defensive_move(board, human)] = computer_marker
    else
      board[board.unmarked_keys.sample] = computer_marker
    end
  end

  private

  def set_name
    @name = ["WALL-E", "AG3", "Bender", "Optimus Prime", "Vicky"].sample
  end
end

class Human < Player
  attr_accessor :turn

  def initialize
    @turn = nil
    super
  end

  def assign_marker(answer)
    @marker = answer
  end

  def joinor(arr)
    arr.length == 1 ? arr[0] : "#{arr[0..-2].join(', ')} or #{arr[-1]}"
  end

  def move(board)
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end
    board[square] = marker
  end

  def assign_turn(answer)
    @turn = case answer
            when 'y' then FIRST_PLAYER
            when 'n' then SECOND_PLAYER
            end
    @starting_turn = @turn
  end

  def reset_turn
    @turn = @starting_turn
  end

  private

  def set_name
    system 'clear'
    n = ""
    loop do
      puts "Whats your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    @name = n
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

  def reset_score
    initialize
  end

  def detect_grand_winner(human_name, computer_name)
    return unless grand_winner?
    puts "\nGrand winner is..."
    num("human") == ROUNDS ? puts("#{human_name}!") : puts("#{computer_name}!")
    reset_score
  end
end

# game orchestration engine
class TTTGame
  attr_reader :board, :human, :computer, :scoreboard

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @scoreboard = ScoreBoard.new
  end

  def play
    clear
    display_welcome_message
    select_marker
    select_first_player
    clear
    main_game
    display_goodbye_message
  end

  private

  def select_marker
    answer = nil
    loop do
      puts "Select a marker: (X or O)"
      answer = gets.chomp.upcase
      break if %w(X O).include?(answer)
      puts "Sorry, that's not a valid choice"
    end
    human.assign_marker(answer)
    computer.assign_marker(answer)
  end

  def select_first_player
    answer = nil
    loop do
      puts "Would you like to go first? (y, n, choose)"
      answer = gets.chomp
      break if %w(y n choose).include?(answer)
      puts "Sorry, that's not a valid choice."
    end
    answer = ['y', 'n'].sample if answer == 'choose'
    human.assign_turn(answer)
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

  def player_move
    loop do
      current_player_turn
      break if board.someone_won? || board.full?

      clear_screen_and_display_board
      human.turn += 1
    end
  end

  def current_player_turn
    human.turn.odd? ? human.move(board) : computer.move(board, human)
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe #{human.name}!"
    puts "You're playing against #{computer.name}."
    puts ""
    puts "The player who wins #{ScoreBoard::ROUNDS} rounds is the grand winner!"
    puts ""
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name} is a #{computer.marker}."
    board.draw
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
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
    puts "\n#{human.name}: #{scoreboard.num('human')}"
    puts "#{computer.name}: #{scoreboard.num('computer')}"
    scoreboard.detect_grand_winner(human.name, computer.name)
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
    human.reset_turn
  end

  def display_play_again_message
    puts "Let's play again!"
  end
end

game = TTTGame.new
game.play
