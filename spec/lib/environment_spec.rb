require_relative '../../lib/environment'

require 'numo/narray'

RSpec.describe Environment do
  before(:each) do
    srand(0)
  end

  subject do 
    s = described_class.new
    s.reset
    s
  end

  describe '#reset' do    
    it "initializes the environment" do
      expect(subject.player.position).to eq(Numo::NArray[5, 0])
      expect(subject.food.position).to eq(Numo::NArray[3, 3])
      expect(subject.enemy.position).to eq(Numo::NArray[7, 9])
    end
  end

  describe '#observation' do
    it 'returns the distances of food and enemy to the player' do
      expect(subject.observation).to eq([2, -3, -2, -9])
    end
  end

  describe '#step' do
    it 'performs the action and returns observation, reward and done' do
      expect(subject.step(6)).to eq([[2, -2, -2, -8], -1, false])
    end

    it 'returns enemy reward and done' do
      subject.step(0)
      subject.step(0)
      subject.step(6)
      subject.step(6)
      subject.step(6)
      subject.step(6)
      subject.step(6)
      subject.step(6)
      expect(subject.step(6)).to eq( [[4, 6, 0, 0], -300, true])
    end

    it 'returns food reward and done' do
      subject.step(2)
      subject.step(2)
      expect(subject.step(6)).to eq( [[0, 0, -4, -6], 25, true])
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the environment' do
      expect(subject.to_s).to eq(
        [
          "0",
          "------------",
          "|          |",
          "|          |",
          "|          |",
          "|   O      |",
          "|          |",
          "|#         |",
          "|          |",
          "|         X|",
          "|          |",
          "|          |",
          "------------"
        ].join("\n")
      )
    end
  end
end
