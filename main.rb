require_relative 'libs/blackjack_exceptions'
require_relative 'libs/validation'
require_relative 'libs/card'
require_relative 'libs/deck'
require_relative 'libs/hand'
require_relative 'libs/player'
require_relative 'libs/dealer'
require_relative 'libs/interface_helpers'
require_relative 'libs/blackjack_interface'

# Main class of the game
class Blackjack
  include BlackjackExceptions

  attr_accessor :deck, :player, :dealer
  attr_reader :ui

  def initialize(user_interface)
    @ui = user_interface
    @deck = Deck.new
    @dealer = Dealer.new
  end

  def run
    start_game
    game
    end_game
  end

  private

  def setup_players
    with_is_empty_handling do
      name = ui.ask_name
      @player = Player.new(name)
    end
    @partners = [@dealer, @player]
  end

  def start_game
    ui.start_game
    setup_players
  end

  def setup_new_game
    @partners.each { |partner| partner.hand.release_cards(@deck) }
    @partners.each { |partner| partner.hand.take_card(@deck, 2) }
    @open_cards = false
    make_bets
  end

  def game
    loop do
      setup_new_game
      game_round
      round_end

      break if no_money
      break unless ui.ask_continue
    end
  end

  def no_money
    no_money = @partners.select(&:bankrupt?)
    ui.no_money(no_money)
    !no_money.size.zero?
  end

  def make_bets
    @jackpot = 0
    @partners.each { |partner| @jackpot += partner.make_bet }
    true
  end

  def round_end
    winner = who_win
    winner ? winner.score += @jackpot : split_jackpot
    ui.round_end(winner, @partners)
  end

  def split_jackpot
    @partners.each { |parnter| parnter.score += (@jackpot / 2) }
  end

  def who_win
    return @player if @player.hand.max_points > @dealer.hand.max_points
    return @dealer if @player.hand.max_points < @dealer.hand.max_points

    nil
  end

  def game_round
    loop do
      ui.round(@partners)
      player_choose
      @dealer.move(@deck) unless @open_cards
      three_cards = @player.hand.cards.size == 3 && @dealer.hand.cards.size == 3

      break if @open_cards || three_cards
    end
  end

  def player_choose
    selected = ui.choose(@player)
    @open_cards = true if selected == :open
    @player.hand.take_card(@deck) if selected == :take
  end

  def end_game
    ui.end_game
  end
end

Blackjack.new(BlackjackInterface.new).run
