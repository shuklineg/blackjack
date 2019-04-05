# exception catching module
module Exceptions
  NameIsEmpty = Class.new(StandardError)

  def with_name_is_empty_handling
    yield
  rescue NameIsEmpty => e
    puts e.message
    retry
  end
end
