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
    with_name_is_empty_handling do
      name = ask('Ведите свое имя?')
      @player = Player.new(name)
    end
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start_game
    greetins
    setup_players
  end

  def setup_new_game
    @player.release_cards(@deck)
    @dealer.release_cards(@deck)
    @open_cards = false
    @player.take_card(@deck, 2)
    @dealer.take_card(@deck, 2)
  end

  def game
    loop do
      setup_new_game
      loop do
        make_bets
        break if game_round
      end
      round_end

      break if ask('Вы хотите продолжить?(Д/н)').downcase.first == 'н'
    end
  end

  def make_bets
    @jackpot = 0
    @jackpot += @player.bet
    @jackpot += @dealer.bet
  end

  def round_end
    winner = who_win
    winner.score += @jackpot if winner
    split_jackpot unless winner
    print_congratulation(winner, @player, @dealer)
    @jackpot = 0
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
    choose = player_choose
    @open_cards = true if choose == :open_cards
    @player.take_card(@deck) if choose == :take_card
    @dealer.move(@deck) unless @open_cards
    three_cards = @player.cards.size == 3 && @dealer.cards.size == 3
    @open_cards || three_cards
  end

  def player_choose
    get_one_char('Ваш ход: (В)зять/(Открыть)/(П)ропустить') do |char|
      return :open_cards if char == 'о'
      return :take_card if char == 'в'
      return :skip if char == 'п'
    end
  end

  def end_game
    print_score_table(@player, @dealer)
    puts wrapped_line('Конец игры!', '***')
  end
end

Blackjack.new.run
