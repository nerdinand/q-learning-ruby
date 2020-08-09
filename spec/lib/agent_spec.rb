require_relative '../../lib/agent'

require 'numo/narray'

RSpec.describe Agent do
  before(:each) do
    srand(0)
  end

  subject { described_class.new(10) }

  describe '#position' do    
    it "returns the agent's position" do
      expect(subject.position).to eq(Numo::NArray[5, 0])
    end
  end

  describe '#action' do
    context 'action = 0' do
      let(:action) { 0 }

      it 'moves the agent' do
        subject.action(action)

        expect(subject.position).to eq(Numo::NArray[6, 1])
      end
    end


    context 'action = 6' do
      let(:action) { 6 }

      it 'moves the agent' do
        subject.action(action)

        expect(subject.position).to eq(Numo::NArray[5, 1])
      end
    end

    context 'action = 8' do
      let(:action) { 8 }

      it "doesn't move the agent" do
        subject.action(action)

        expect(subject.position).to eq(Numo::NArray[5, 0])
      end
    end
  end

  describe '#move' do
    context 'without x and y parameters' do
      it 'moves the agent by a random offset' do
        subject.move
        subject.move

        expect(subject.position).to eq(Numo::NArray[6, 0])
      end
    end

    context 'with x and y paramters' do
      it 'moves the agent by the given offset' do
        subject.move(2, 2)

        expect(subject.position).to eq(Numo::NArray[7, 2])
      end
    end

    context 'with x and y parameters that would move the agent off the board' do
      it "doesn't move the agent off the board" do
        subject.move(-20, 20)

        expect(subject.position).to eq(Numo::NArray[0, 9])
      end
    end
  end
end
