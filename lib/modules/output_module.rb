module OutputModule
  def suggest_to_guess_secret_number
    puts 'Try to guess the secret number'
  end

  def show_user_info(attempts, hint)
    puts "You have: #{attempts} attempts, #{hint} hints."
  end

  def show_result(result)
    case result
      when 'win'
        puts 'You win !!!'
      when 'lose'
        puts 'You have not guessed the secret code! You lose.'
    end
  end

  def play_again
    puts 'Do you want to play again? (Y - yes,N - no)'
  end

  def incorrect_input
    puts 'Incorrect input!'
  end

  def show_answer(answer)
    puts answer
  end

  def no_hints
    puts 'You have used all your hints!'
  end
end