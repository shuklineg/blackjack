# player class
class Player
  include BlackjackExceptions
  include Validation

  DEFAULT_SCORE = 100
  DEFAULT_BET = 10

  attr_accessor :score
  attr_reader :name, :bet, :hand

  validate :name, :presence

  def initialize(name)
    @name = name
    @score = DEFAULT_SCORE
    @bet = DEFAULT_BET
    @hand = Hand.new
    validate!
  end

  def make_bet
    return 0 if bankrupt?

    @score -= @bet
    @bet
  end

  def bankrupt?
    @score - @bet < 0
  end
end
