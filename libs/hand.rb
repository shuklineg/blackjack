# Player Hand implementation class
class Hand
  CARDS_MAX_COUNT = 3

  attr_accessor :cards

  def initialize
    @cards = []
    @points = [0]
  end

  def max_points
    @points.select { |val| val <= 21 }.max || 0
  end

  def release_cards(deck)
    deck.cards += @cards
    @cards.clear
    @points = [0]
  end

  def take_card(deck, count = 1)
    return false if cards_max_count?

    count.times do
      new_card = deck.random_card
      @points = @points.product(new_card.points).map(&:sum).uniq
      @cards << new_card
    end
    true
  end

  def cards_max_count?
    @cards.count >= CARDS_MAX_COUNT
  end
end
