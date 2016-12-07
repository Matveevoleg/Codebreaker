require_relative '../modules/output_module'
require_relative '../modules/save_module'
require_relative '../modules/mark_module'

module Codebreaker
  class Game
    include(OutputModule)
    include(SaveModule)
    include(MarkModule)

    attr_reader :hint, :attempts

    HINTS = 2
    ATTEMPTS = 5
    CODEBREAKER_FILE = 'codebreaker.txt'

    def initialize
      @secret_code = generate_secret_code
      @attempts = ATTEMPTS
      @hint = HINTS
    end

    def start
      Game.new.play
    end

    def play
      while @attempts != 0
        suggest_to_guess_secret_number
        show_user_info
        result = user_input

        case result
          when 'hint'
            get_hint
          when 'win'
            end_game('win')
          else
            show_answer(result)
        end

        @attempts -= 1
      end

      end_game('lose')
    end

    def end_game(result)
      show_result(result)
      save_result(get_user_data, CODEBREAKER_FILE)
      suggest_to_play_again
    end

    def suggest_to_play_again
      play_again
      start if get_input == 'y'
      exit
    end

    def get_hint
      @attempts += 1

      return no_hints if @hint == 0

      show_hint(@secret_code)
      @hint -= 1
    end

    def user_input
      input = get_input

      return get_answer(input) if correct_input?(input)

      @attempts += 1
      incorrect_input
    end

    def get_input
      gets.chomp.downcase
    end

    def get_user_data
      puts 'Enter your name'
      name = get_input
      name.center(10) + ' | ' + (HINTS - @hint).to_s.center(5) + ' | ' + (ATTEMPTS - @attempts).to_s.center(8) + ' | '
    end

    private

    def generate_secret_code
      Array.new(4) { rand(6) + 1 }.join
    end
  end
end
