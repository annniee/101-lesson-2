GAME_LIMIT = 21
DEALER_LIMIT = 17
CARD_VALUE = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
               '8' => 8, '9' => 9, '10' => 10, 'Jack' => 10, 'Queen' => 10,
               'King' => 10 }.freeze
POINTS_TO_WIN = 5

def prompt(msg)
  puts "==> #{msg}"
end

def joinand(hand)
  case hand.length
  when 1
    hand[0][0]
  when 2
    "#{hand[0][0]} and #{hand[1][0]}"
  else
    values = hand.map { |card| card[0] }
    "#{values[0..-2].join(', ')} and #{values[-1]}"
  end
end

def welcome
  system 'clear' || system('cls')
  puts "Welcome to #{GAME_LIMIT}!"
end

def start_new_round(n)
  sleep(1)
  puts "New round. First player to score #{n} points wins."
  puts '----------------------------------------------------'
  sleep(1)
end

def initialize_deck
  suits = %w(D C H S)
  values = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  deck = suits.each_with_object([]) do |suit, cards|
    values.each { |value| cards << [value, suit] }
  end
  deck.shuffle
end

def draw_card!(deck)
  deck.pop
end

def deal_cards(deck, dealer_hand, player_hand)
  puts ' '
  prompt('Dealing cards...')
  2.times do
    player_hand << draw_card!(deck)
    dealer_hand << draw_card!(deck)
  end
  sleep(2)
  puts "Dealer has: #{dealer_hand[0][0]} and unknown card"
  puts "You have: #{joinand(player_hand)}. (Total: #{total(player_hand)})"
  puts ' '
end

def total(hand)
  total = 0

  hand.select { |card| card[0] != 'Ace' }.each do |card|
    total += CARD_VALUE[card[0]]
  end

  hand.select { |card| card[0] == 'Ace' }.length.times do
    total += (total + 11 > GAME_LIMIT ? 1 : 11)
  end

  total
end

def bust?(hand)
  total(hand) > GAME_LIMIT
end

def valid_input?(input, valid_choices)
  valid_choices.include?(input)
end

def hit_or_stay
  ans = nil
  loop do
    sleep(1)
    prompt("Do you want to hit or stay? (enter 'h' or 's'):")
    ans = gets.chomp.downcase
    break if valid_input?(ans, %w(h s))
    puts 'Sorry, that is not a valid response.'
  end
  prompt(ans == 'h' ? 'You chose to hit...' : 'You chose to stay...')
  ans
end

def player_turn!(deck, player_hand)
  loop do
    answer = hit_or_stay
    if answer == 'h'
      sleep(2)
      player_hand << draw_card!(deck)
      prompt "You drew #{player_hand[-1][0]}. (Total: #{total(player_hand)})"
      puts ' '
    end
    break if bust?(player_hand) || answer == 's'
  end
end

def display_all_cards(dealer_hand, player_hand)
  sleep(1)
  puts ' '
  puts "Dealer has: #{joinand(dealer_hand)}. (Total: #{total(dealer_hand)})"
  puts "You have: #{joinand(player_hand)}. (Total: #{total(player_hand)})"
  puts ' '
end

# rubocop: disable Metrics/MethodLength
def detect_result(dealer_hand, player_hand)
  dealer_total = total(dealer_hand)
  player_total = total(player_hand)
  if bust?(player_hand)
    :player_bust
  elsif bust?(dealer_hand)
    :dealer_bust
  elsif player_total > dealer_total
    :player
  elsif player_total < dealer_total
    :dealer
  elsif player_total == dealer_total
    :tie
  end
end
# rubocop: enable Metrics/MethodLength

def display_winner(dealer_hand, player_hand)
  result = detect_result(dealer_hand, player_hand)
  sleep(1)
  case result
  when :player_bust then puts 'You busted. Dealer won.'
  when :dealer_bust then puts 'Dealer busted. You won!'
  when :player then puts 'You won!'
  when :dealer then puts 'Dealer won.'
  when :tie then puts 'It\'s a tie.'
  end
end

def dealer_turn!(deck, dealer_hand, player_hand)
  display_all_cards(dealer_hand, player_hand)
  loop do
    break if total(dealer_hand) >= DEALER_LIMIT
    sleep(2)
    dealer_hand << draw_card!(deck)
    prompt "Dealer drew #{dealer_hand[-1][0]}. (Total: #{total(dealer_hand)})"
    puts ' '
  end
end

def play_again?
  ans = nil
  loop do
    puts ' '
    sleep(2)
    prompt('Do you want to play again? (Y/N)')
    ans = gets.chomp.downcase
    break if valid_input?(ans, %w(y n))
    puts 'Sorry, that is not a valid response'
  end
  ans == 'y'
end

loop do
  welcome
  dealer_score = 0
  player_score = 0

  loop do
    start_new_round(POINTS_TO_WIN)

    deck = initialize_deck
    player_cards = []
    dealer_cards = []
    deal_cards(deck, dealer_cards, player_cards)

    player_turn!(deck, player_cards)
    dealer_turn!(deck, dealer_cards, player_cards) unless bust?(player_cards)

    display_winner(dealer_cards, player_cards)

    result = detect_result(dealer_cards, player_cards)
    dealer_score += 1 if result == :dealer || result == :player_bust
    player_score += 1 if result == :player || result == :dealer_bust

    sleep(4)
    system 'clear' || system('cls')
    prompt "Dealer score: #{dealer_score}, Your score: #{player_score}"
    break if player_score == POINTS_TO_WIN || dealer_score == POINTS_TO_WIN
    puts '----------------------------------------------------'
  end
  sleep(1)
  puts(player_score == POINTS_TO_WIN ? 'You won!' : 'Dealer won.')
  break unless play_again?
end

puts "Thanks for playing #{GAME_LIMIT}!"
