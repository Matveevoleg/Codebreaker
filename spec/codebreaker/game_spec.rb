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
    describe '#get_hint' do
      it 'should return string with hint' do
        expect(game.get_hint).to match(/[-]*[0-6][-]*/)
      end

      it 'should reduce hints number by -1' do
        allow(game).to receive(:show_hint)

        expect{game.get_hint}.to change{game.hints}.by(-1)
      end

      it 'should reduce attempts number by 1' do
        allow(game).to receive(:show_hint)

        expect{game.get_hint}.to change{game.attempts}.by(1)
      end

      it 'should write no hint string when hint = 0' do
        game.instance_variable_set(:@hints, 0)

        expect(game.get_hint).to eq(nil)
      end
    end

    describe '#get_answer' do
      data = [
          ['1111', '1111', 'win'],
          ['1111', 'hint', 'hint'],
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
          ['3331','3332','+++'],
          ['1113','1112','+++'],
          ['1312','1212','+++'],
          ['1234','1266','++'],
          ['1234','6634','++'],
          ['1234','1654','++'],
          ['1234','1555','+'],
          ['1234','4321','----'],
          ['5432','2345','----'],
          ['1234','2143','----'],
          ['1221','2112','----'],
          ['5432','2541','---'],
          ['1145','6514','---'],
          ['1244','4156','--'],
          ['1221','2332','--'],
          ['2244','4526','--'],
          ['5556','1115','-'],
          ['1234','6653','-'],
          ['3331','1253','--'],
          ['2345','4542','+--'],
          ['1243','1234','++--'],
          ['4111','4444','+'],
          ['1532','5132','++--'],
          ['3444','4334','+--'],
          ['1113','2155','+'],
          ['2245','4125','+--'],
          ['4611','1466','---'],
          ['5451','4445','+-']
      ]

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

      describe '#reduce_attempts' do
        it 'should reduce attempts number by 1' do
         expect{game.reduce_attempts}.to change{game.attempts}.by(-1)
      end
    end
  end
end
