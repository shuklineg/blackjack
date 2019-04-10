# Interface class
class BlackjackInterface
  include InterfaceHelpers

  def start_game
    puts title('Blackjack')
    puts wrapped_line('Добро пожаловать в игру!', '***')
  end

  def ask_name
    ask('Ведите свое имя?')
  end

  def ask_continue
    ask('Вы хотите продолжить?(Д/н)').downcase.chars.first != 'н'
  end

  def no_money(partners)
    partners.each { |partner| puts "У #{partner.name} недостаточно средств" }
  end

  def round(partners)
    partners.each do |partner|
      print_player_status(partner, partner.class == Player)
    end
  end

  def end_game
    puts wrapped_line('Конец игры!', '***')
  end

  def print_player_status(player, opened = true)
    puts "Игрок #{player.name}\n\tкарт #{player.hand.cards.size}"
    return unless opened

    print_cards(player)
  end

  def print_cards(player)
    puts "\tочков #{player.hand.max_points}\n"
    puts "Карты:\n\t#{player.hand.cards.join("\n\t")}"
  end

  def open_cards(partners)
    puts wrapped_line('Открываем карты', '***')
    partners.each { |partner| print_player_status(partner) }
  end

  def score(partners)
    puts wrapped_line('Всего очков', '***')
    partners.each { |partner| puts "#{partner.name} - #{partner.score}" }
  end

  def round_end(winner, partners)
    open_cards(partners)
    puts wrapped_line('Результат партии', '***')
    puts title(winner ? "Выиграл #{winner.name}" : 'Ничья')
    score(partners)
  end

  def choose(player)
    take = player.hand.cards_max_count? ? '' : '(В)зять'
    loop do
      char = ask_not_empty("Ваш ход: #{take}(О)ткрыть/(П)ропустить")
             .chars.first.downcase
      return :take if char == 'в' && !take.empty?
      return :skip if char == 'п'
      return :open if char == 'о'
    end
  end
end
