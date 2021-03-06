# BlackjackExceptions module
module BlackjackExceptions
  IsEmpty = Class.new(StandardError)

  def with_is_empty_handling
    yield
  rescue BlackjackExceptions::IsEmpty => e
    puts e.message
    retry
  end
end
