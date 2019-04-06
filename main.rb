require_relative 'libs/exceptions'
require_relative 'libs/validation'
require_relative 'libs/card'
require_relative 'libs/deck'
require_relative 'libs/player'
require_relative 'libs/dealer'
require_relative 'libs/interface_helpers'

# Main class of the game
class Blackjack
  include InterfaceHelpers
  include Exceptions

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
      @player = Player.new(name, @deck)
    end
    @dealer = Dealer.new(@deck)
  end

  def start_game
    greetins
    @deck = Deck.new
    setup_players
  end

  def setup_new_game
    @player.release_cards
    @dealer.release_cards
    @open_cards = false
    @player.take_card(2)
    @dealer.take_card(2)
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
    @jackpot = 0
    @jackpot += @player.bet
    @jackpot += @dealer.bet
    true
  rescue NotEnoughMoney => e
    puts e.message
    false
  end

  def round_end
    winner = who_win
    winner ? winner.score += @jackpot : split_jackpot
    @jackpot = 0
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
    return @player if @player.points > @dealer.points
    return @dealer if @player.points < @dealer.points

    nil
  end

  def game_round
    print_dealer_status(@dealer)
    print_player_status(@player)
    player_choose
    @dealer.move unless @open_cards
    three_cards = @player.cards.size == 3 && @dealer.cards.size == 3
    @open_cards || three_cards
  end

  def player_choose
    get_one_char('Ваш ход: (В)зять/(О)ткрыть/(П)ропустить') do |char|
      return @open_cards = true if char == 'о'
      return true if char == 'п'

      begin
        return @player.take_card if char == 'в'
      rescue TooManyCards => e
        puts e.message
      end
    end
  end

  def end_game
    puts wrapped_line('Таблица результатов', '***')
    print_score_table(@player, @dealer)
    puts wrapped_line('Конец игры!', '***')
  end
end

Blackjack.new.run
