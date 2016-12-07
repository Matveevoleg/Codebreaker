module MarkModule
  def correct_input? (value)
    return true if value == 'hint'
    /^[1-6]{4}$/.match(value) ? true : false
  end

  def get_answer (input)
    return 'win' if input == @secret_code
    return input if input == 'hint'

    answer = ''
    secret_code = @secret_code.chars
    user_code = input

    secret_code.each_with_index do |ch, i |
      if ch == input[i]
        answer << '+'
        secret_code[i] = '_'
        input[i] = '-'
      end
    end

    secret_code.each do |ch|
      if user_code.include? ch
        answer << '-'
        input[input.index(ch)] = '-'
      end
    end

    answer
  end
end