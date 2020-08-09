require_relative 'environment'

class Statistics
  def initialize
    @cumulative_rewards = []
    @final_rewards = []
    @numbers_of_steps = []
  end

  def update(cumulative_reward, final_reward, number_of_steps)
    cumulative_rewards << cumulative_reward
    final_rewards << final_reward
    numbers_of_steps << number_of_steps
  end

  def calculate(last_n_episodes)
    @every_cumulative_rewards = cumulative_rewards[-last_n_episodes..-1] || []
    @every_final_rewards = final_rewards[-last_n_episodes..-1] || []
    @every_numbers_of_steps = numbers_of_steps[-last_n_episodes..-1] || []
  end

  def to_s
    "mean reward: #{every_cumulative_rewards.sum / every_cumulative_rewards.size.to_f}
max reward: #{every_cumulative_rewards.max}
min reward: #{every_cumulative_rewards.min}
mean number of steps: #{every_numbers_of_steps.sum / every_cumulative_rewards.size.to_f}
max number of steps: #{every_numbers_of_steps.max}
min number of steps: #{every_numbers_of_steps.min}
win rate: #{every_final_rewards.count(Environment::FOOD_REWARD) / every_final_rewards.size.to_f}
lose rate: #{every_final_rewards.count(Environment::ENEMY_REWARD) / every_final_rewards.size.to_f}
timeout rate: #{every_final_rewards.count(Environment::MOVE_REWARD) / every_final_rewards.size.to_f}"
  end

  attr_reader :cumulative_rewards, :final_rewards, :numbers_of_steps, :every_cumulative_rewards, :every_final_rewards, :every_numbers_of_steps
end
