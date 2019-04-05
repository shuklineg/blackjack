# Deck of cards
class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    generate
  end

  def random_card
    card = @cards.sample
    @cards.delete card
    card
  end

  private

  def generate
    ["\u2660", "\u2663", "\u2665", "\u2666"].each do |suit|
      (2..10).each { |points| @cards << Card.new(suit, points, points.to_s) }
      %w[К Д В].each { |face| @cards << Card.new(suit, 10, face) }
      cards << Card.new(suit, [1, 11], 'Т')
    end
  end
end
