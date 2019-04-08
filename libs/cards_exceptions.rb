# exception catching module
module CardsExceptions
  IsEmpty = Class.new(StandardError)
  NotEnoughMoney = Class.new(StandardError)
  TooManyCards = Class.new(StandardError)

  def with_is_empty_handling
    yield
  rescue CardsExceptions::IsEmpty => e
    puts e.message
    retry
  end
end
