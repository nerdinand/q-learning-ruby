# frozen_string_literal: true

require_relative 'environment'
require_relative 'agent'
require_relative 'statistics'

require 'numo/gsl'

# Implementation of Q-Learning algorithm
class QLearning
  def initialize
    @q_table = initialize_q_table(Environment::SIZE)
    @statistics = Statistics.new
    @epsilon = INITIAL_EPSILON.dup
  end

  attr_reader :q_table, :statistics

  def train_episode(environment) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    cumulative_reward = 0
    done = false
    steps = 0

    until done
      steps += 1
      old_observation = environment.observation
      action = determine_action(old_observation)

      new_observation, reward, done = environment.step(action)

      max_future_q = q_table[new_observation].max
      current_q = q_table[old_observation][action]

      new_q = if reward == Environment::FOOD_REWARD
                Environment::FOOD_REWARD
              else
                (1.0 - LEARNING_RATE) * current_q + LEARNING_RATE * (reward + DISCOUNT * max_future_q)
              end
      q_table[old_observation][action] = new_q

      final_reward = reward
      cumulative_reward += reward
    end

    statistics.update(cumulative_reward, final_reward, steps)
    @epsilon *= EPSILON_DECAY_RATE
  end

  def play_environment_step(environment)
    observation = environment.observation
    action = q_table[observation].max_index # exploit
    _, _, done = environment.step(action)
    done
  end

  def save_q_table(path)
    File.binwrite(path, Marshal.dump(q_table))
  end

  def load_q_table(path)
    @q_table = Marshal.load(File.read(path)) # rubocop:disable Security/MarshalLoad
  end

  private

  def initialize_q_table(size) # rubocop:disable Metrics/MethodLength
    from = -size + 1
    to = size

    rand = Numo::GSL::Rng::Rand.new
    q_table = {}

    from.upto(to).each do |x1|
      from.upto(to).each do |y1|
        from.upto(to).each do |x2|
          from.upto(to).each do |y2|
            q_table[[x1, y1, x2, y2]] = rand.flat(-5, 0, Agent::ACTION_COUNT)
          end
        end
      end
    end

    q_table
  end

  def determine_action(observation)
    if rand > @epsilon
      q_table[observation].max_index # exploit
    else
      rand(0...Agent::ACTION_COUNT) # explore
    end
  end
end
