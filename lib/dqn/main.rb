require_relative 'agent'
require_relative '../environment'

DISCOUNT = 0.99
REPLAY_MEMORY_SIZE = 50_000
MIN_REPLAY_MEMORY_SIZE = 1_000
MINIBATCH_SIZE = 64  # How many steps (samples) to use for training
UPDATE_TARGET_EVERY = 5

MODEL_NAME = 'linear-128-64'
MIN_REWARD = -200  # For model save

EPISODES = 20_000

@epsilon = 1  # not a constant, going to be decayed
EPSILON_DECAY = 0.99975
MIN_EPSILON = 0.001

AGGREGATE_STATS_EVERY = 50  # episodes

environment = Environment.new
@agent = DQN::Agent.new

episode_rewards = []
episode_losses = []

def determine_action(observation)
  if rand > @epsilon
    @agent.get_qs(observation).argmax # exploit
  else
    DQN::Agent::ACTION_SPACE.sample # explore
  end
end

0.upto(EPISODES).each do |episode|
  episode_reward = 0
  step = 1

  current_observation = environment.reset

  done = false

  until done
    action = determine_action(current_observation)

    new_observation, reward, done = environment.step(action)
    episode_reward += reward

    @agent.update_replay_memory([current_observation, action, reward, new_observation, done])
    loss = @agent.train(done)

    episode_losses << loss if loss

    current_observation = new_observation
    step += 1
  end

  episode_rewards.append(episode_reward)

  if !episode.zero? && (episode % AGGREGATE_STATS_EVERY).zero?
    last_episode_rewards = episode_rewards[-AGGREGATE_STATS_EVERY..] || []
    average_reward = last_episode_rewards.sum / last_episode_rewards.size
    min_reward = last_episode_rewards.min
    max_reward = last_episode_rewards.max

    last_episode_losses = episode_losses[-AGGREGATE_STATS_EVERY..] || []
    average_loss = last_episode_losses.sum / last_episode_losses.size
    
    puts "Episode #{episode}. Epsilon: #{@epsilon} Rewards: avg %.2f, min %.2f, max %.2f. Loss: avg %.2f" % [average_reward, min_reward, max_reward, average_loss]

    # Save model, but only when min reward is greater or equal a set value
    if average_reward >= MIN_REWARD
      @agent.model.save("data/#{MODEL_NAME}__%.2favg_%.2fmin_%.2fmax__#{Time.now.to_i}.pth" % [average_reward, min_reward, max_reward])
    end
  end

  if @epsilon > MIN_EPSILON
    @epsilon *= EPSILON_DECAY
    @epsilon = [MIN_EPSILON, @epsilon].max
  end
end