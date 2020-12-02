class Deck
  SUITS = ["Clubs", "Diamonds", "Hearts", "Spades"]
  CARD_VAL = ["K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2", "A"]

  def initialize
    @deck = []
    SUITS.each do |suit|
      CARD_VAL.each do |val|
        @deck << Card.new(val, suit)
      end
    end
    @deck.shuffle!
  end

  def deal!(participant, num=1)
    @deck.shift(num).each { |card| participant.hand << card }
  end
end

class Card
  attr_reader :face

  def initialize(value, suit)
    @face = [value, suit]
  end
end

class Participant
  attr_accessor :hand, :name, :bust, :stay

  def initialize
    @name = set_name
    @hand = []
    @bust = false
    @stay = false
  end

  def convert_score(value)
    if value == "A"
      11
    elsif value.match?(/[KQJ]/)
      10
    else
      value.to_i
    end
  end

  def total
    values = @hand.map { |obj| obj.face[0] }
    score = values.map { |value| convert_score(value) }.sum
    correct_aces(score, values)
  end

  def correct_aces(score, values)
    if score > 21
      values.count { |value| value == "A" }.times { score -= 10 }
    end
    score
  end

  def busted?
    self.bust = true if total > 21
  end

  def display_hand(num)
    cards = @hand.map(&:face)
    num.times { |idx| puts "=> #{cards[idx][0]} of #{cards[idx][1]}" }
  end

  def show_cards
    puts "\n-----#{@name}'s hand-----"
    display_hand(hand.length)
    puts "\nWhich adds up to: #{total}"
  end

  def hit(deck)
    deck.deal!(self)
  end

  def display_stay
    return unless stay
    puts "\n#{@name} stays!"
  end

  def display_hit
    puts "\n#{@name} hits!"
  end
end

class Player < Participant
  def set_name
    system 'clear'
    answer = ""
    loop do
      puts "Whats your name?"
      answer = gets.chomp.strip
      break unless answer.empty?
      puts "Sorry, must enter a value."
    end
    @name = answer
  end

  def move(deck)
    choice = nil
    loop do
      puts "\nWould you like to 'hit' or 'stay'?"
      choice = gets.chomp
      break if %w(hit stay).include?(choice)
      puts "Sorry that's not a valid answer"
    end
    hit(deck) if choice == 'hit'
    display_hit if choice == 'hit'
    self.stay = true if choice == 'stay'
  end
end

class Dealer < Participant
  def set_name
    @name = ["WALL-E", "AG3", "Bender", "Optimus Prime", "Vicky"].sample
  end

  def move(deck)
    puts "\n#{@name} reveals unknown card..."
    loop do
      break if total >= 17
      show_cards
      break if total >= 17
      hit(deck)
      display_hit
    end
    self.stay = true if total <= 21
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to 21 #{player.name}!"
    puts "Your dealer today is #{dealer.name}."
  end

  def display_goodbye_message
    puts "\nThanks for playing 21! Goodbye!"
  end

  def deal_cards
    deck.deal!(player, 2)
    deck.deal!(dealer, 2)
  end

  def show_initial_cards
    puts "\n#{dealer.name} has:"
    dealer.display_hand(1)
    puts "=> and one unknown card"

    puts "\nYou were dealt:"
    player.display_hand(2)
    puts "which adds up to: #{player.total}"
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

  def show_result
    puts "========================="
    show_result_dealer
    show_result_player
    puts "========================="
    display_bust
  end

  def show_result_dealer
    puts "#{dealer.name}'s final cards are:"
    dealer.display_hand(dealer.hand.length)
    puts "Total: #{dealer.total}"
  end

  def show_result_player
    puts "\nYour final cards are:"
    player.display_hand(player.hand.length)
    puts "Total: #{player.total}"
  end

  def display_bust
    if player.total > 21
      puts "You Busted! #{dealer.name} wins!"
    elsif dealer.total > 21
      puts "#{dealer.name} Busted! You win!"
    end
    display_winner
  end

  def display_winner
    dealer_total = dealer.total
    player_total = player.total
    if dealer_total < player_total && player_total <= 21
      puts "You win!"
    elsif dealer_total > player_total && dealer_total <= 21
      puts "#{dealer.name} wins!"
    elsif dealer_total == player_total
      puts "It's a tie! No one wins!"
    end
  end

  def reset
    clear
    puts "Lets play again!"
    @deck = Deck.new
    player.hand = []
    player.bust = false
    player.stay = false
    dealer.hand = []
    dealer.bust = false
    dealer.stay = false
  end

  def turn(participant)
    loop do
      participant.move(deck)
      break participant.display_stay if participant.stay
      participant.show_cards
      participant.busted? ? display_bust : next
      break
    end
  end

  def start
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def main_game
    loop do
      deal_cards
      show_initial_cards

      turn(player)
      unless player.stay
        break unless play_again?
        next reset
      end
      turn(dealer)
      unless dealer.stay
        break unless play_again?
        next reset
      end

      show_result
      break unless play_again?
      reset
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end

Game.new.start
