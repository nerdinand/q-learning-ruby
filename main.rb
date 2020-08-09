require 'curses'
require_relative 'lib/q_learning'
require_relative 'lib/environment'

LEARNING_RATE = 0.1
DISCOUNT = 0.95
EPISODES = 150_000
SHOW_EVERY = 1000

INITIAL_EPSILON = 0.8 # closer to 0: more exploiting, closer to 1: more exploring
EPSILON_DECAY_RATE = 0.9999 # decay epsilon by this amount every episode

def show_example_play(q_learning, play_output_line_start)
  play_environment = Environment.new
  play_environment.reset

  Curses.setpos(play_output_line_start, 0)
  Curses.addstr(play_environment.to_s)
  Curses.refresh

  done = false
  while !done
    sleep 0.1
    done = q_learning.play_environment_step(play_environment)

    Curses.setpos(play_output_line_start, 0)
    Curses.addstr(play_environment.to_s)
    Curses.refresh
  end
end

e = Environment.new
e.reset

Curses.init_screen
Curses.start_color 
Curses.noecho
Curses.cbreak

begin
  q_learning = QLearning.new

  0.upto(EPISODES).each do |episode|
    environment = Environment.new
    environment.reset

    if episode % SHOW_EVERY == 0
      q_learning.statistics.calculate(SHOW_EVERY)
      statistics_string = "Episode #{episode}\n#{q_learning.statistics}"
      statistics_line_count = statistics_string.lines.count
      play_output_line_start = statistics_line_count + 2
      Curses.setpos(0, 0)
      Curses.addstr(statistics_string)
      Curses.refresh
    end

    if episode % 10000 == 0
      show_example_play(q_learning, play_output_line_start)
    end

    q_learning.train_episode(environment)
  end

  q_learning.save_q_table("data/#{Time.now.strftime('%Y-%m-%d-%H%M%S')}-q-table.dump")
  
  Curses.getch
ensure
  Curses.close_screen
end
