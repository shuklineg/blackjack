require_relative 'libs/errors'
require_relative 'libs/player'
require_relative 'libs/interface_helpers'

# Main class of the game
class Blackjack
  include Errors

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
  end

  def start_game
    greetins
    setup_players
  end

  def setup_new_game
    @player.release_cards(@deck)
    @dealer.release_cards(@deck)
    @open_cards = false
    @player.take_cards(@deck, 2)
    @dealer.take_cards(@deck, 2)
  end

  def game
    loop do
      setup_new_game
      loop do
        break if game_round
      end
      update_score_and_print
      break if ask('Вы хотите продолжить?(Д/н)').downcase.first == 'н'
    end
  end

  def game_round
    print_dealer_status(@dealer)
    print_player_status(@player)
    choose = player_choose
    @open_cards = true if choose == :open_cards
    @player.take_card if choose == :take_card
    @dealer.move unless @open_cards
    three_cards = @player.cards.size == 3 && @dealer.cards.size == 3
    @open_cards || three_cards
  end

  def player_choose
    get_one_char('Ваш ход: (В)зять/(Открыть)/(П)ропустить') do |char|
      return :open_cards if char == 'о'
      return :take_card if char == 'в'
      return :skip if char == 'п'

      return nil
    end
  end

  def end_game
    print_score_table(@player, @dealer)
    puts wrapped_line('Конец игры!', '***')
  end
end

Blackjack.new.run
