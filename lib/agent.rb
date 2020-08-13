# frozen_string_literal: true

require 'numo/narray'

# Entity that acts in the Environment. Has x and y position and can move around.
class Agent
  ACTION_SPACE = (0..8).to_a

  def initialize(size)
    @size = size
    @x = random_coordinate
    @y = random_coordinate
  end

  def position
    Numo::NArray[@x, @y]
  end

  def action(choice) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
    case choice
    when 0
      move(x: 1, y: 1)
    when 1
      move(x: -1, y: -1)
    when 2
      move(x: -1, y: 1)
    when 3
      move(x: 1, y: -1)

    when 4
      move(x: 1, y: 0)
    when 5
      move(x: -1, y: 0)

    when 6
      move(x: 0, y: 1)
    when 7
      move(x: 0, y: -1)

    when 8
      move(x: 0, y: 0)
    end
  end

  def move(x: false, y: false) # rubocop:disable Naming/MethodParameterName
    # If no value for x, move randomly
    @x += x || random_movement

    # If no value for y, move randomly
    @y += y || random_movement

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
