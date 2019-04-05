# Dealer class implementation
class Dealer < Player
  include Validation

  validate :name, :presence

  def initialize(deck)
    super 'Dealer', deck
  end

  def move
    take_card if points < 17 && @cards.size < 3
  end
end
