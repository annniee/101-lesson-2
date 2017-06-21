VALID_CHOICES = %w(rock paper scissors lizard spock)

WIN = { 'rock' => %w(lizard scissors),
        'lizard' => %w(spock paper),
        'spock' => %w(scissors rock),
        'scissors' => %w(paper lizard),
        'paper' => %w(rock spock) }

def prompt(message)
  Kernel.puts(">> #{message}")
end

def valid_choice_arr(user_input)
  VALID_CHOICES.select { |choice| choice.start_with?(user_input) }
end

def display_results(player, computer)
  puts "You chose: #{player}; Computer chose: #{computer}"

  if WIN[player].include?(computer)
    puts "You won!"
  elsif player == computer
    puts "It's a tie!"
  else
    puts "Computer won!"
  end
end

def invalid_input
  system('clear') || system('cls')
  prompt("Not sure what you meant.")
end

Kernel.puts("Welcome to #{VALID_CHOICES.map(&:capitalize).join(', ')} Game!")

loop do
  system('clear') || system('cls')
  player_choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}:")
    player_choice = Kernel.gets().chomp()

    if VALID_CHOICES.include?(player_choice)
      break
    elsif valid_choice_arr(player_choice).length == 1
      player_choice = valid_choice_arr(player_choice)[0]
      break
    else
      invalid_input
    end
  end

  computer_choice = VALID_CHOICES.sample()

  display_results(player_choice, computer_choice)

  answer = ''
  loop do
    prompt("Do you want to play again? y/n")
    answer = Kernel.gets().chomp().downcase
    break if %w(y yes n no).include?(answer)
    invalid_input
  end

  next if answer.start_with?('y')

  break if answer.start_with?('n')
end

puts("Thank you for playing, good-bye!")
