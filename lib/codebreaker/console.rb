require_relative '../modules/output_module'
require_relative 'game'

module Codebreaker
  class Console
    include(OutputModule)

    def initialize
      @game = Game.new
    end

    def start
      while @game.attempts != 0
        suggest_to_guess_secret_number
        show_user_info(@game.attempts, @game.hints)
        result = user_input

        case result
          when 'hint'
            hint = @game.get_hint
            no_hints unless hint
            show_answer(hint)
          when 'win'
            end_game('win')
          else
            show_answer(result)
        end

        @game.reduce_attempts
      end

      end_game('lose')
    end

    def end_game(result)
      show_result(result)
      @game.save(get_user_data)
      suggest_to_play_again
    end

    def user_input
      input = get_input

      return @game.get_answer(input) if correct_input?(input)

      incorrect_input
    end

    def correct_input? (value)
      return true if value == 'hint'
      /^[1-6]{4}$/.match(value) ? true : false
    end

    def get_input
      gets.chomp.downcase
    end

    def get_user_data
      puts 'Enter your name'
      name = get_input
      name.center(10) + ' | ' + (@game.hints).to_s.center(5) + ' | ' + (@game.attempts).to_s.center(8) + ' | '
    end

    def suggest_to_play_again
      play_again
      exit unless get_input == 'y'
      @game = Game.new
      start
    end
  end
end
