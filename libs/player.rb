# player class
class Player
  include Exceptions
  include Validation

  attr_accessor :score, :cards

  validate :name, :presence

  DEFAULT_SCORE = 100
  DEFAULT_BET = 10

  def initialize(name)
    @name = name
    @score = DEFAULT_SCORE
    @cards = []
    validate!
  end

  def bet
    bet = DEFAULT_BET
    raise NotEnoughMoney if @score - bet < 0

    @score -= bet
    bet
  end

  def points
    raise NotEmplimentedError
  end

  def release_cards(deck)
    deck.cards += @cards
    @cards.clear
  end

  def take_card(deck, count = 1)
    return if @cards.size + count > 3

    count.times do
      new_card = deck.random_card
      @cards << new_card
    end
  end
end
