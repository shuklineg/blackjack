# Interface helpers module
module InterfaceHelpers
  def title(text)
    result = "+#{'-'*text.size}+\n"
    result << wrapped_line(text, '|')
    result << "\n+#{'-'*text.size}+\n"
  end

  def wrapped_line(text, wrap)
    "#{wrap}#{text}#{wrap}"
  end

  def ask(prompt)
    print "#{prompt}: "
    gets.strip
  end

  def print_dealer_status(dealer)
    # TODO: print dealer status
  end

  def print_player_status(player)
    # TODO: print player status
  end

  def get_one_char(prompt)
    return unless block_given?

    loop do
      break if yield(ask(prompt).downcase.chars.first)
    end
  end
end
