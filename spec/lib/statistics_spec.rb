require_relative '../../lib/statistics'

RSpec.describe Statistics do
  subject { described_class.new }

  describe '#update' do
    it 'adds rewards to an array' do
      subject.update(1, 2, 23)

      expect(subject.cumulative_rewards).to eq([1])
      expect(subject.final_rewards).to eq([2])
      expect(subject.numbers_of_steps).to eq([23])

      subject.update(3, 4, 42)

      expect(subject.cumulative_rewards).to eq([1, 3])
      expect(subject.final_rewards).to eq([2, 4])
      expect(subject.numbers_of_steps).to eq([23, 42])
    end
  end

  context 'subject with some statistics' do
    subject do
      described_class.new.tap do |s|
        s.update(1, -1, 23)
        s.update(3, 25, 42)
        s.update(5, -300, 128)
      end
    end

    describe '#calculate' do
      context 'last_n_episodes = 3' do
        it 'aggregates the last 3 episodes' do
          subject.calculate(3)

          expect(subject.every_cumulative_rewards).to eq([1, 3, 5])
          expect(subject.every_final_rewards).to eq([-1, 25, -300])
          expect(subject.every_numbers_of_steps).to eq([23, 42, 128])
        end
      end

      context 'last_n_episodes = 2' do
        it 'aggregates the last 2 episodes' do
          subject.calculate(2)

          expect(subject.every_cumulative_rewards).to eq([3, 5])
          expect(subject.every_final_rewards).to eq([25, -300])
          expect(subject.every_numbers_of_steps).to eq([42, 128])
        end
      end
    end

    describe '#to_s' do
      it 'returns a string of statistics' do
        subject.calculate(3)

        expect(subject.to_s).to eq("mean reward: 3.0
max reward: 5
min reward: 1
mean number of steps: 64.33333333333333
max number of steps: 128
min number of steps: 23
win rate: 0.3333333333333333
lose rate: 0.3333333333333333
timeout rate: 0.3333333333333333")
      end
    end
  end
end