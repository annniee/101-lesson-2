# Loan Calculator

require 'yaml'
MESSAGES = YAML.load_file("mtg_calc_msgs.yml")

def prompt(msg)
  Kernel.puts ">> #{msg}"
end

def valid_number?(amt)
  (amt.to_i.to_s == amt || amt.to_f.to_s == amt) && amt.to_f >= 0
end

prompt(MESSAGES['welcome'])

# largest loop starts here
loop do
  loan_amount = ''
  loop do
    prompt(MESSAGES["loan_amount"])
    loan_amount = Kernel.gets().chomp()
    break if valid_number?(loan_amount)
    prompt(MESSAGES["valid_num"])
  end

  annual_percentage_rate = ''
  loop do
    prompt(MESSAGES["apr"])
    annual_percentage_rate = Kernel.gets().chomp()
    break if valid_number?(annual_percentage_rate)
    prompt(MESSAGES["valid_num"])
  end

  loan_duration_in_years = ''
  loop do
    prompt(MESSAGES["loan_duration_in_years"])
    loan_duration_in_years = Kernel.gets().chomp()
    break if valid_number?(loan_duration_in_years)
    prompt(MESSAGES["valid_num"])
  end

  # calculations:
  monthly_interest_rate = (annual_percentage_rate.to_f / 12) / 100
  loan_duration_in_months = loan_duration_in_years.to_f * 12

  monthly_payment = loan_amount.to_f *
                    (monthly_interest_rate /
                    (1 - (1 + monthly_interest_rate)**-loan_duration_in_months))

  monthly_payment = monthly_payment.round(2)

  # output to user:
  prompt("Your monthly payment will be $#{monthly_payment}")
  prompt(MESSAGES["again"])
  answer = Kernel.gets().chomp().downcase
  break unless answer.start_with?("y")

  system('clear') || system('cls')
end

prompt(MESSAGES["thanks_bye"])
