# q-learning-ruby
A toy implementation of Q-Learning in Ruby

Roughly inspired and based on [pythonprogramming.net Q-Learning tutorial](https://pythonprogramming.net/q-learning-reinforcement-learning-python-tutorial/).

The environment is a 10x10 2D grid with 3 distinct entities that start with random positions:
* An agent (denoted with `#`) in the output. It is the thing we train to act in the environment to earn the biggest reward possible. Every movement the agent takes that doesn't end the game is rewarded with -1. This encourages the agent to find the goal as quickly as possible.
* An enemy (denoted with `X`). It is an obstacle to avoid in the game. If the agent hits it, the episode is over and the reward is -300.
* A piece of food (denoted with `O`). Reaching this is the goal in the game. If the agent navigates on top of it, the episode is over and the reward is 25.

## Setup

Because this depends on the [numo-gsl gem](https://github.com/ruby-numo/numo-gsl), GSL is required to be installed. On macOS, using [Homebrew](https://brew.sh) just run

```
brew install gsl
```

Then install the Ruby gems using bundler:

```
bundle install
```

## Running

To train a Q-Learning agent, run:

```
ruby main.rb
```

This uses ncurses to show a CLI user interface during training. You will see different training statistics that show that the agent is learning. By default, 200'000 episodes are trained. This only takes a couple of minutes and will result in an agent that plays the game perfectly. Every 10000 episodes, an example game is played.

### Example output

```
Episode 26000
mean reward: 15.664
max reward: 25
min reward: -307
mean number of steps: 8.061
max number of steps: 103
min number of steps: 1
win rate: 0.993
lose rate: 0.007
timeout rate: 0.002


2
------------
|          |
|          |
|          |
|          |
|          |
|          |
|X  #      |
|          |
|          |
|          |
------------
```

## Testing

`bundle exec rake` runs the [RSpec](https://rspec.info/) tests and [RuboCop](https://rubocop.org/).
