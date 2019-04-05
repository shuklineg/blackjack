# Dealer class implementation
class Dealer < Player
  include Validation

  validate :name, :presence

  def initialize
    super 'Dealer'
  end

  def move(deck); end
end
