# player class
class Player
  include Exceptions
  include Validation

  attr_accessor :score, :cards
  attr_reader :name

  validate :name, :presence

  DEFAULT_SCORE = 100
  DEFAULT_BET = 10

  def initialize(name, deck)
    @name = name
    @deck = deck
    @score = DEFAULT_SCORE
    @cards = []
    @points = [0]
    validate!
  end

  def bet
    bet = DEFAULT_BET
    bankrupt = @score - bet < 0
    raise NotEnoughMoney, "У игрока #{name} недостаточно средств" if bankrupt

    @score -= bet
    bet
  end

  def points
    @points.select { |val| val <= 21 }.max || 0
  end

  def release_cards
    @deck.cards += @cards
    @cards.clear
    @points = [0]
  end

  def take_card(count = 1)
    return if @cards.size + count > 3

    count.times do
      new_card = @deck.random_card
      new_points = []
      new_card.points.each do |card_points|
        new_points += @points.map { |val| val + card_points }
      end
      @points = new_points
      @cards << new_card
    end
  end
end
