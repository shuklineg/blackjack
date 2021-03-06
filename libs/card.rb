# Card implementation class
class Card
  attr_reader :suit, :face, :points

  def initialize(suit, points, face)
    @suit = suit
    @points = points
    @points = [@points] unless @points.is_a? Array
    @face = face
  end

  def to_s
    "#{@suit} #{@face}"
  end
end
