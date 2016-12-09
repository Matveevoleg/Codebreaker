module MarkModule
  def answer(input)
    answer_string = ''
    secret_code = @secret_code.chars
    user_code = input

    secret_code.each_with_index do |ch, i |
      if ch == input[i]
        answer_string << '+'
        secret_code[i] = '_'
        input[i] = '-'
      end
    end

    secret_code.each do |ch|
      if user_code.include? ch
        answer_string << '-'
        input[input.index(ch)] = '-'
      end
    end

    answer_string
  end

  def hint
    output_string = '---'
    number = rand(0..3)
    output_string.insert(number,@secret_code[number])
  end
end