require_relative 'libs/errors'
require_relative 'libs/player'
require_relative 'libs/interface_helpers'

class Blackjack
  include Errors

  attr_accessor :deck, :player, :dealer

  def run
    start_game
    game
    end_game
  end

  private 

  def start_game
    puts title('Blackjack')
    puts wrapped_line('Добро пожаловать в игру!', '***')    
    begin
      name = ask('Ведите свое имя?')
      @player = Player.new(name)
    rescue NotEmpty => e
      puts e.message
      retry
    end
    @dealer = Dealer.new
  end

  def game
    loop do
      @open_cards = false
      @player.take_cards(@deck, 2)
      @dealer.take_cards(@deck, 2)      
      loop do
        break if turn
      end
      break if ask('Вы хотите продолжить?(Д/н)').downcase.first == 'н'
    end
  end

  def turn
    # TODO turn
    show_player_status
    # TODO choose
    three_cards = @player.cards.size == 3 && @dealer.cards.size == 3
    @open_cards || three_cards
  end

  def end_game
    print_score_table(@player, @dealer)
    puts wrapped_line('Конец игры!', '***')
  end
end

Blackjack.new.run