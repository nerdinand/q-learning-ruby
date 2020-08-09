# frozen_string_literal: true

require_relative 'environment'

# Gathers and calculates statistics during training
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
    @every_cumulative_rewards = cumulative_rewards[-last_n_episodes..] || []
    @every_final_rewards = final_rewards[-last_n_episodes..] || []
    @every_numbers_of_steps = numbers_of_steps[-last_n_episodes..] || []
  end

  def to_s # rubocop:disable Metrics/AbcSize
    "mean reward: #{mean(every_cumulative_rewards)}
max reward: #{every_cumulative_rewards.max}
min reward: #{every_cumulative_rewards.min}
mean number of steps: #{mean(every_numbers_of_steps)}
max number of steps: #{every_numbers_of_steps.max}
min number of steps: #{every_numbers_of_steps.min}
win rate: #{rate(every_final_rewards, Environment::FOOD_REWARD)}
lose rate: #{rate(every_final_rewards, Environment::ENEMY_REWARD)}
timeout rate: #{rate(every_final_rewards, Environment::MOVE_REWARD)}"
  end

  attr_reader :cumulative_rewards, :final_rewards, :numbers_of_steps, :every_cumulative_rewards,
              :every_final_rewards, :every_numbers_of_steps

  private

  def mean(array)
    array.sum / array.size.to_f
  end

  def rate(array, occurence)
    array.count(occurence) / array.size.to_f
  end
end
