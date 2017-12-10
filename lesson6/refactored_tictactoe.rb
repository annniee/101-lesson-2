INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
FIRST = :choose

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, delimiter = ', ', word = 'or ')
  case arr.size
  when 1 then arr[0].to_s
  when 2 then arr[0].to_s + ' ' + word + arr[1].to_s
  else
    arr[-1] = word + arr[-1].to_s
    arr.join(delimiter)
  end
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

# rubocop: disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd)
  system 'clear' || system('cls')
  prompt('Player is X. Computer is O.')
  puts ''
  puts '     |     |     '
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts '     |     |     '
  puts '-----|-----|-----'
  puts '     |     |     '
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts '     |     |     '
  puts '-----|-----|-----'
  puts '     |     |     '
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts '     |     |     '
  puts ''
end
# rubocop: enable Metrics/AbcSize, Metrics/MethodLength

def available_squares(brd)
  brd.select { |_, v| v == INITIAL_MARKER }.keys
end

def player_turn!(brd)
  display_board(brd)
  choice = ''

  loop do
    prompt("Please choose a square (#{joinor(available_squares(brd))}):")
    choice = gets.chomp.to_i
    break if available_squares(brd).include?(choice)
    prompt("Sorry, that's not a valid choice")
  end

  brd[choice] = PLAYER_MARKER
end

def at_risk_squares(brd, marker)
  squares = []
  WINNING_LINES.each do |line|
    values = brd.values_at(line[0], line[1], line[2])
    if (values.count(INITIAL_MARKER) == 1) && (values.count(marker) == 2)
      squares << line.select { |sq| brd[sq] == INITIAL_MARKER }
    end
  end
  squares.flatten!
end

def computer_turn!(brd)
  if at_risk_squares(brd, COMPUTER_MARKER)
    brd[at_risk_squares(brd, COMPUTER_MARKER).sample] = COMPUTER_MARKER
  elsif at_risk_squares(brd, PLAYER_MARKER)
    brd[at_risk_squares(brd, PLAYER_MARKER).sample] = COMPUTER_MARKER
  elsif available_squares(brd).include?(5) && available_squares(brd).size != 9
    brd[5] = COMPUTER_MARKER
  else
    brd[available_squares(brd).sample] = COMPUTER_MARKER
  end
end

def winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).uniq == [PLAYER_MARKER]
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).uniq == [COMPUTER_MARKER]
      return 'Computer'
    end
  end
  nil
end

def winner?(brd)
  winner(brd) == 'Player' || winner(brd) == 'Computer'
end

def tie?(brd)
  available_squares(brd).empty?
end

def place_piece!(brd, current_player)
  if current_player == :player
    player_turn!(brd)
  elsif current_player == :computer
    computer_turn!(brd)
  end
end

def alternate_player(current_player)
  if current_player == :player
    :computer
  elsif current_player == :computer
    :player
  end
end

def game_play(brd, first_player)
  current_player = first_player
  loop do
    place_piece!(brd, current_player)
    current_player = alternate_player(current_player)
    break if winner?(brd) || tie?(brd)
  end
  display_board(brd)
  display_winner(brd)
end

def display_winner(brd)
  if winner?(brd)
    puts "#{winner(brd)} won this round!"
  elsif tie?(brd)
    puts "It's a tie!"
  end
end

def yes?(question)
  input = ''
  loop do
    prompt(question)
    input = gets.chomp.downcase
    break if input == 'y' || input == 'n'
    prompt('Please enter Y or N')
  end
  input == 'y'
end

def who_is_first(first)
  case first
  when :player then :player
  when :computer then :computer
  when :choose
    yes?('Do you want to go first? Y/N') ? :player : :computer
  end
end

# GAME START:
loop do
  player_score = 0
  computer_score = 0
  n = 5

  first_player = who_is_first(FIRST)

  loop do
    board = initialize_board

    game_play(board, first_player)

    if winner(board) == 'Player'
      player_score += 1
      first_player = :player
    elsif winner(board) == 'Computer'
      computer_score += 1
      first_player = :computer
    end

    break if player_score == n || computer_score == n

    puts "Current score: Player: #{player_score}, Computer: #{computer_score}"
    puts "First player to #{n} points wins."
    break unless yes?('Continue to next round? Y/N')
  end

  puts "Final score: Player: #{player_score}, Computer: #{computer_score}!"
  break unless yes?('Do you want to play again? (Y or N)')
end

prompt('Thanks for playing Tic Tac Toe! Good bye.')
