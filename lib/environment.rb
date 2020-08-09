# frozen_string_literal: true

require_relative 'agent'

# The environment for Agents to act in.
class Environment
  SIZE = 10
  MOVE_REWARD = -1
  FOOD_REWARD = 25
  ENEMY_REWARD = -300
  MAX_EPISODE_LENGTH = 200

  attr_reader :player, :food, :enemy

  def reset
    @player = Agent.new(SIZE)
    @food = Agent.new(SIZE)

    @food = Agent.new(SIZE) while @food.position == @player.position

    @enemy = Agent.new(SIZE)
    @enemy = Agent.new(SIZE) while @enemy.position == @player.position || @enemy.position == @food.position

    @episode_step = 0
  end

  def observation
    (@player.position - @food.position).append(
      @player.position - @enemy.position
    ).to_a
  end

  def step(action) # rubocop:disable Metrics/MethodLength
    @episode_step += 1
    @player.action(action)

    # enemy.move()
    # food.move()

    reward = if @player.position == @enemy.position
               ENEMY_REWARD
             elsif @player.position == @food.position
               FOOD_REWARD
             else
               MOVE_REWARD
             end

    done = reward == FOOD_REWARD || reward == ENEMY_REWARD || @episode_step >= MAX_EPISODE_LENGTH

    [observation, reward, done]
  end

  def to_s # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    string = @episode_step.to_s
    string << "\n"
    string << '-' * (SIZE + 2)
    string << "\n"
    0.upto(SIZE - 1).each do |x|
      string << '|'
      0.upto(SIZE - 1).each do |y|
        string << case [x, y]
                  when @player.position
                    '#'
                  when @food.position
                    'O'
                  when @enemy.position
                    'X'
                  else
                    ' '
                  end
      end
      string << '|'
      string << "\n"
    end
    string << '-' * (SIZE + 2)

    string
  end
end
