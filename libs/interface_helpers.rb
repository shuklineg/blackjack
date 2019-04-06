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

  def print_dealer_status(dealer)
    puts "Игрок #{dealer.name}"
    puts "\tсчет #{dealer.score}"
    puts "\tкарт #{dealer.cards.size}"
  end

  def print_player_status(player)
    print_dealer_status(player)
    puts "\tочков #{player.points}"
    puts "\Карты:"
    player.cards.each { |card| puts "\t\t#{card}" }
  end

  def print_congratulation(winner)
    puts wrapped_line('Результат партии', '***')
    puts title(winner ? "Выиграл #{winner.name}" : 'Ничья')
  end

  def get_one_char(prompt)
    return unless block_given?

    loop do
      break if yield(ask(prompt).downcase.chars.first)
    end
  end

  def print_score_table(*players)
    scores = score_table(*players)
    score_table(*players).keys.sort.reverse.each_with_index do |result, index|
      puts "#{index + 1}. #{result} - #{scores[result].map(&:name).join(',')}"
    end
  end

  private

  def score_table(*players)
    scores = {}
    players.each do |some_player|
      scores[some_player.score] ||= []
      scores[some_player.score] << some_player
    end
    scores
  end
end
