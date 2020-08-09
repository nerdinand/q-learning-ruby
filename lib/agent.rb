require 'numo/narray'

class Agent
  ACTION_COUNT = 9

  def initialize(size)
    @size = size
    @x = random_coordinate
    @y = random_coordinate
  end

  def position
    Numo::NArray[@x, @y]
  end

  def action(choice)
    case choice
    when 0
      move(1, 1)
    when 1
      move(-1, -1)
    when 2
      move(-1, 1)
    when 3
      move(1, -1)

    when 4
      move(1, 0)
    when 5
      move(-1, 0)

    when 6
      move(0, 1)
    when 7
      move(0, -1)

    when 8
      move(0, 0)
    end
  end

  def move(x = false, y = false)
    # If no value for x, move randomly
    @x += if x
      x
    else
      random_movement
    end

    # If no value for y, move randomly
    @y += if y
      y
    else
      random_movement
    end

    # If we are out of bounds, fix!
    @x = @x.clamp(0, @size - 1)
    @y = @y.clamp(0, @size - 1)
  end

  private

  def random_coordinate
    (0...@size).to_a.sample
  end

  def random_movement
    [-1, 0, 1].sample
  end
end
