# Loan Calculator

require 'yaml'
MESSAGES = YAML.load_file("mtg_calc_msgs.yml")

def prompt(msg)
  Kernel.puts ">> #{msg}"
end

def valid_number?(str_amt)
  (str_amt.to_i.to_s == str_amt) ||
    (format("%.2f", str_amt.to_f.to_s) == str_amt) &&
      (str_amt.to_f > 0)
end

def ask_for(mtg_info, mtg_info_var)
  loop do
    prompt("Please enter the #{mtg_info}:")
    mtg_info_var = Kernel.gets().chomp()
    break if valid_number?(mtg_info_var)
    prompt(MESSAGES["valid num"])
  end
  mtg_info_var
end

prompt(MESSAGES['welcome'])

# largest loop starts here
loop do
  # obtain input from user (3x)
  loan_amount = ''
  loan_amount = ask_for("loan amount", loan_amount)

  annual_percentage_rate = ''
  annual_percentage_rate = ask_for("annual percentage rate (APR)",
                                   annual_percentage_rate)

  loan_duration_in_years = ''
  loan_duration_in_years = ask_for("loan duration in years",
                                   loan_duration_in_years)

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
  again = Kernel.gets().chomp().downcase
  if again == ("n" || "no")
    break
  elsif again == ("y" || "yes")
    next
  else
    prompt("Not sure what you meant")
    break
  end

  system('clear') || system('cls')
end

prompt(MESSAGES["thanks_bye"])
