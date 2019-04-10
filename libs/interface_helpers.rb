# Interface helpers module
module InterfaceHelpers
  def title(text)
    result = "+#{'-' * text.size}+\n"
    result << wrapped_line(text, '|')
    result << "\n+#{'-' * text.size}+\n"
  end

  def wrapped_line(text, wrap)
    "#{wrap}#{text}#{wrap}"
  end

  def ask(prompt)
    print "#{prompt}: "
    gets.strip
  end

  def ask_not_empty(prompt)
    loop do
      print "#{prompt}: "
      val = gets.strip

      return val unless val.empty?
    end
  end
end
