require_relative '../modules/save_module'
require_relative '../modules/mark_module'

module Codebreaker
  class Game
    include(SaveModule)
    include(MarkModule)

    attr_reader :hints, :attempts

    HINTS = 2
    ATTEMPTS = 5
    CODEBREAKER_FILE = 'codebreaker.txt'

    def initialize
      @secret_code = generate_secret_code
      @attempts = ATTEMPTS
      @hints = HINTS
    end

    def save(user_data)
      save_result(user_data, CODEBREAKER_FILE)
    end

    def get_hint
      @attempts += 1
      return if @hints == 0
      @hints -= 1
      hint
    end

    def reduce_attempts
      @attempts -= 1
    end

    def get_answer(input)
      return 'win' if input == @secret_code
      return input if input == 'hint'

      answer(input)
    end
    private

    def generate_secret_code
      Array.new(4) { rand(6) + 1 }.join
    end
  end
end
