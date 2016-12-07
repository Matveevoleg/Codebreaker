require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    subject (:game) { Game.new }

    describe '#generate_secret_code' do
      let(:code) { game.send(:generate_secret_code)}

      it 'generates secret code' do
        expect(code).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(code.length).to eq(4)
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(code).to match(/[1-6]+/)
      end
    end

    describe '#correct_input?' do
      it 'should returns true when entered hint' do
        expect(game.correct_input?('hint')).to be true
      end

      it 'should returns true when entered code with numbers from 1 to 6' do
        expect(game.correct_input?('1356')).to be true
      end

      it 'should returns false when we entered code more than 4 digits' do
        expect(game.correct_input?('13562')).to be false
      end

      it 'should returns false when we entered code less than 4 digits' do
        expect(game.correct_input?('135')).to be false
      end
    end

    describe '#user input' do
      it 'should call :incorrect_input when was entered not valid code' do
        allow(game).to receive(:get_input).and_return('one, two')

        expect(game).to receive(:incorrect_input)
        game.user_input
      end

      it 'should call :get_answer when was entered valid code' do
        input = '1234'
        allow(game).to receive(:get_input).and_return(input)

        expect(game).to receive(:get_answer).with(input)
        game.user_input
      end

      it 'should reduce attempts number by 1' do
        allow(game).to receive(:show_hint)

        expect{game.get_hint}.to change{game.attempts}.by(1)
      end
    end

    describe '#get_hint' do
      it 'should return string with hint' do
        expect{game.get_hint}.to output(/[-]*[0-6][-]*/).to_stdout
      end

      it 'should reduce hints number by -1' do
        allow(game).to receive(:show_hint)

        expect{game.get_hint}.to change{game.hint}.by(-1)
      end

      it 'should reduce attempts number by 1' do
        allow(game).to receive(:show_hint)

        expect{game.get_hint}.to change{game.attempts}.by(1)
      end

      it 'should write no hint string when hint = 0' do
        game.instance_variable_set(:@hint,0)

        expect{game.get_hint}.to output("You have used all your hints!\n").to_stdout
      end
    end

    describe '#suggest_to_play_again' do
      it 'should call :play_again' do
        allow(game).to receive(:exit)

        expect(game).to receive(:play_again)
        game.suggest_to_play_again
      end

      it 'should call :start' do
        allow(game).to receive(:play_again)
        allow(game).to receive(:get_input).and_return('y')
        allow(game).to receive(:exit)

        expect(game).to receive(:start)
        game.suggest_to_play_again
      end

      it 'should call :exit' do
        allow(game).to receive(:play_again)
        allow(game).to receive(:get_input).and_return('n')

        expect(game).to receive(:exit)
        game.suggest_to_play_again
      end
    end

    describe '#get_answer' do
      data = [
          ['1111', '1111', 'win'],
          ['1111', '1115', '+++'],
          ['1111', '1155', '++'],
          ['1111', '1555', '+'],
          ['1111', '5555', ''],
          ['1221', '2112', '----'],
          ['1221', '2114', '---'],
          ['1221', '2155', '--'],
          ['1221', '2555', '-'],
          ['2245', '2254', '++--'],
          ['2245', '2253', '++-'],
          ['2245', '2435', '++-'],
          ['2245', '2533', '+-'],
          ['1234', '4321', '----'],
      ]

      it 'should returns hint' do
        input = 'hint'

        expect(game.get_answer(input)).to eq(input)
      end

      it 'should return win' do
        input = '1111'
        game.instance_variable_set(:@secret_code, input)

        expect(game.get_answer(input)).to eq('win')
      end

      it 'should return ----' do
        input = '1234'
        code = '4321'
        game.instance_variable_set(:@secret_code, code)
        allow(game).to receive(:show_answer)

        expect(game.get_answer(input)).to eq('----')
      end

      it 'should return empty string' do
        input = '1234'
        code = '5555'
        game.instance_variable_set(:@secret_code, code)
        allow(game).to receive(:show_answer)

        expect(game.get_answer(input)).to be_empty
      end

      data.each do |item|
        it "should return #{item[2]} when secret_code is #{item[0]} and input is #{item[1]}" do
          subject.instance_variable_set(:@secret_code, item[0])
          expect(subject.get_answer(item[1])).to eq item[2]
        end
      end
    end

    describe '#end_the_game' do
      before() do
        allow(game).to receive(:save_result)
        allow(game).to receive(:get_user_data)
        allow(game).to receive(:suggest_to_play_again)
      end

      it 'should return win' do
        result = 'win'

        expect{game.end_game(result)}.to output("You win !!!\n").to_stdout
      end

      it 'should return lose' do
        result = 'lose'

        expect{game.end_game(result)}.to output("You have not guessed the secret code! You lose.\n").to_stdout
      end

      it 'should call save method' do
        allow(game).to receive(:show_result)

        expect(game).to receive(:save_result)
        game.end_game('')
      end
    end

    describe '#play' do
      it 'should call :suggest_to_guess_secret_number' do
        allow(game).to receive(:show_user_info)
        allow(game).to receive(:user_input)

        expect{game.play}.to output("Try to guess the secret number\n").to_stdout
        game.play
      end
    end
  end
end
