# Dealer class implementation
class Dealer < Player
  include Validation

  validate :name, :presence

  def initialize
    super 'Dealer'
  end

  def move(deck)
    hand.take_card(deck) if hand.max_points < 17 && !hand.cards_max_count?
  end
end
