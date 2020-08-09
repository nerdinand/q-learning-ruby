require_relative 'agent'

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

    while @food.position == @player.position do
      @food = Agent.new(SIZE)
    end

    @enemy = Agent.new(SIZE)
    while @enemy.position == @player.position || @enemy.position == @food.position do
      @enemy = Agent.new(SIZE)
    end

    @episode_step = 0
  end

  def observation
    (@player.position - @food.position).append(
      @player.position - @enemy.position
    ).to_a
  end

  def step(action)
    @episode_step += 1
    @player.action(action)

    #### MAYBE ###
    #enemy.move()
    #food.move()
    ##############

    reward = if @player.position == @enemy.position
      ENEMY_REWARD
    elsif @player.position == @food.position
      FOOD_REWARD
    else
      MOVE_REWARD
    end

    done = reward == FOOD_REWARD || reward == ENEMY_REWARD || @episode_step >= MAX_EPISODE_LENGTH

    return observation, reward, done
  end

  def to_s
    string = "#{@episode_step}"
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
      string << "|"
      string << "\n"
    end
    string << '-' * (SIZE + 2)

    string
  end
end

