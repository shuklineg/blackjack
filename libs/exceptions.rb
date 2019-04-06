# exception catching module
module Exceptions
  IsEmpty = Class.new(StandardError)
  NotEnoughMoney = Class.new(StandardError)
  TooManyCards = Class.new(StandardError)

  def with_is_empty_handling
    yield
  rescue Exceptions::IsEmpty => e
    puts e.message
    retry
  end
end
