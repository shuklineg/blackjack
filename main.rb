require_relative 'libs/blackjack_exceptions'
require_relative 'libs/validation'
require_relative 'libs/card'
require_relative 'libs/deck'
require_relative 'libs/hand'
require_relative 'libs/player'
require_relative 'libs/dealer'
require_relative 'libs/interface_helpers'

# Main class of the game
class Blackjack
  include InterfaceHelpers
  include BlackjackExceptions

  attr_accessor :deck, :player, :dealer

  def run
    start_game
    game
    end_game
  end

  private

  def greetins
    puts title('Blackjack')
    puts wrapped_line('Добро пожаловать в игру!', '***')
  end

  def setup_players
    with_is_empty_handling do
      name = ask('Ведите свое имя?')
      @player = Player.new(name)
    end
    @dealer = Dealer.new
  end

  def start_game
    greetins
    @deck = Deck.new
    setup_players
  end

  def setup_new_game
    @player.hand.release_cards(@deck)
    @dealer.hand.release_cards(@deck)
    @open_cards = false
    @player.hand.take_card(@deck, 2)
    @dealer.hand.take_card(@deck, 2)
  end

  def game
    loop do
      break unless make_bets

      setup_new_game
      loop do
        break if game_round
      end
      round_end
      break if ask('Вы хотите продолжить?(Д/н)').downcase.chars.first == 'н'
    end
  end

  def make_bets
    puts "У #{@player.name} недостаточно средств" if @player.bankrupt?
    puts "У #{@dealer.name} недостаточно средств" if @dealer.bankrupt?
    return false if @player.bankrupt? || @dealer.bankrupt?

    @jackpot = 0
    @jackpot += @player.make_bet
    @jackpot += @dealer.make_bet
    true
  end

  def round_end
    winner = who_win
    winner ? winner.score += @jackpot : split_jackpot
    puts wrapped_line('Открываем карты', '***')
    print_player_status(@dealer)
    print_player_status(@player)
    print_congratulation(winner)
  end

  def split_jackpot
    @player.score += (@jackpot / 2)
    @dealer.score += (@jackpot / 2)
  end

  def who_win
    return @player if @player.hand.max_points > @dealer.hand.max_points
    return @dealer if @player.hand.max_points < @dealer.hand.max_points

    nil
  end

  def game_round
    print_dealer_status(@dealer)
    print_player_status(@player)
    player_choose
    @dealer.move(@deck) unless @open_cards
    three_cards = @player.hand.cards.size == 3 && @dealer.hand.cards.size == 3
    @open_cards || three_cards
  end

  def player_choose
    get_one_char('Ваш ход: (В)зять/(О)ткрыть/(П)ропустить') do |char|
      @open_cards = true if char == 'о'
      puts 'Пропуск хода' if char == 'п'
      puts 'Не больше 3х карт' if char == 'в' && !@player.hand.take_card(@deck)
      return true if %w[о п в].include? char

      false
    end
  end

  def end_game
    puts wrapped_line('Таблица результатов', '***')
    print_score_table(@player, @dealer)
    puts wrapped_line('Конец игры!', '***')
  end
end

Blackjack.new.run
