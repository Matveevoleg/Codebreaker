require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    subject (:console) {Console.new}
    let (:game) {console.instance_variable_get(:@game)}
    describe '#correct_input?' do
      it 'should returns true when entered hint' do
        expect(console.correct_input?('hint')).to be true
      end

      it 'should returns true when entered code with numbers from 1 to 6' do
        expect(console.correct_input?('1356')).to be true
      end

      it 'should returns false when we entered code more than 4 digits' do
        expect(console.correct_input?('13562')).to be false
      end

      it 'should returns false when we entered code less than 4 digits' do
        expect(console.correct_input?('135')).to be false
      end

      it 'should returns false when we entered some string' do
        expect(console.correct_input?('adfhdfa')).to be false
      end
    end

    describe '#user input' do
      it 'should call :incorrect_input when was entered not valid code' do
        allow(console).to receive(:get_input).and_return('one, two')

        expect(console).to receive(:incorrect_input)
        console.user_input
      end

      it 'should call :get_answer when was entered valid code' do
        input = '1234'
        allow(console).to receive(:get_input).and_return(input)
        allow(game).to receive(:get_answer).with(input)

        expect(game).to receive(:get_answer).with(input)
        console.user_input
      end
    end

    describe '#suggest_to_play_again' do
      it 'should call :play_again' do
        allow(console).to receive(:get_input).and_return('y')
        allow(console).to receive(:start)
        allow(console).to receive(:play_again)

        expect(console).to receive(:play_again)
        console.suggest_to_play_again
      end

      it 'should show string play again' do
        allow(console).to receive(:get_input).and_return('y')
        allow(console).to receive(:start)

        expect{console.play_again}.to output("Do you want to play again? (Y - yes,N - no)\n").to_stdout
      end

      it 'should call :start' do
        allow(console).to receive(:play_again)
        allow(console).to receive(:get_input).and_return('y')

        expect(console).to receive(:start)
        console.suggest_to_play_again
      end

      it 'should call :exit' do
        allow(console).to receive(:play_again)
        allow(console).to receive(:get_input).and_return('n')
        allow(console).to receive(:start)

        expect(console).to receive(:exit)
        console.suggest_to_play_again
      end
    end

    describe '#end_the_game' do
      before() do
        allow(game).to receive(:save)
        allow(console).to receive(:get_user_data)
        allow(console).to receive(:suggest_to_play_again)
      end

      it 'should return win' do
        result = 'win'

        expect{console.end_game(result)}.to output("You win !!!\n").to_stdout
      end

      it 'should return lose' do
        result = 'lose'

        expect{console.end_game(result)}.to output("You have not guessed the secret code! You lose.\n").to_stdout
      end

      it 'should call save method' do
        expect(game).to receive(:save)
        console.end_game('')
      end
    end

    describe '#start show methods' do
      before() do
        game.instance_variable_set(:@attempts, 1)
        allow(console).to receive(:end_game)
        allow(console).to receive(:user_input)
      end

      it 'should call :suggest_to_guess_secret_number method' do
        allow(console).to receive(:show_user_info)

        expect(console).to receive(:suggest_to_guess_secret_number)
        console.start
      end

      it 'should write string suggest' do
        allow(console).to receive(:show_user_info)

        expect{console.suggest_to_guess_secret_number}.to output("Try to guess the secret number\n").to_stdout
      end

      it 'should call :show_user_info method' do
        allow(console).to receive(:suggest_to_guess_secret_number)

        expect(console).to receive(:show_user_info)
        console.start
      end

      it 'should write string info' do
        attempts = 1
        hints = 2

        allow(console).to receive(:suggest_to_guess_secret_number)

        expect{console.show_user_info(attempts, hints)}.to output("You have: #{attempts} attempts, #{hints} hints.\n").to_stdout
      end
    end

    describe '#start' do
      before() do
        game.instance_variable_set(:@attempts, 1)
        allow(console).to receive(:suggest_to_guess_secret_number)
        allow(console).to receive(:show_user_info)
      end

      it 'should call :and_game with lose' do
        game.instance_variable_set(:@attempts, 0)

        expect(console).to receive(:end_game).with('lose')
        console.start
      end

      it 'should call :and_game with win' do
        allow(console).to receive(:end_game).with('lose')
        allow(console).to receive(:user_input).and_return('win')

        expect(console).to receive(:end_game).with('win')
        console.start
      end

      it 'should show hint' do
        hint = '---1'
        allow(console).to receive(:user_input).and_return('hint')
        allow(game).to receive(:get_hint).and_return(hint)
        allow(console).to receive(:end_game).with('lose')

        expect(console).to receive(:show_answer).with(hint)
        console.start
      end

      it 'should call :no_hints method' do
        game.instance_variable_set(:@hints, 0)

        allow(console).to receive(:user_input).and_return('hint')
        allow(game).to receive(:get_hint)
        allow(console).to receive(:end_game).with('lose')

        expect(console).to receive(:no_hints)
        console.start
      end
    end
  end
end