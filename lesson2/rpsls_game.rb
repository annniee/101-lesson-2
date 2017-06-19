VALID_CHOICES = %w(rock paper scissors lizard spock)

def prompt(message)
  Kernel.puts(">> #{message}")
end

def display_results(player, computer)
  win = { 'rock' => %w(lizard scissors),
          'lizard' => %w(spock paper),
          'spock' => %w(scissors rock),
          'scissors' => %w(paper lizard),
          'paper' => %w(rock spock) }

  puts "You chose: #{player}; Computer chose: #{computer}"

  if win[player].include?(computer)
    puts "You won!"
  elsif player == computer
    puts "It's a tie!"
  else
    puts "Computer won!"
  end
end

Kernel.puts("Welcome to #{VALID_CHOICES.map(&:capitalize).join(', ')} Game!")

loop do
  player_choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}:")
    player_choice = Kernel.gets().chomp()

    if VALID_CHOICES.include?(player_choice)
      break
    elsif VALID_CHOICES.select { |x| x.start_with?(player_choice) }.length == 1
      player_choice =
        VALID_CHOICES.select { |x| x.start_with?(player_choice) }[0]
      break
    else
      prompt("Not sure what you meant.")
    end
  end

  computer_choice = VALID_CHOICES.sample()

  display_results(player_choice, computer_choice)

  prompt("Do you want to play again? y/n")
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?("y")
  system('clear') || system('cls')
end

puts("Thank you for playing, good-bye!")
