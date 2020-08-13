require 'torch'

require_relative 'fixed_length_queue'
require_relative 'model'

module DQN
  class Agent
    ACTION_SPACE = (0..8).to_a

    def initialize
      @model = Model.new

      @target_model = Model.new
      @target_model.load_state_dict(@model.state_dict)

      @replay_memory = FixedLengthQueue.new(REPLAY_MEMORY_SIZE)

      @target_update_counter = 0

      @optimizer = Torch::Optim::Adam.new(@model.parameters, lr: 0.001)

      use_cuda = Torch::CUDA.available?
      @device = Torch.device(use_cuda ? "cuda" : "cpu")
    end

    attr_reader :model

    # transition: (observation space, action, reward, new observation space, done)
    def update_replay_memory(transition)
      @replay_memory << transition
    end

    def get_qs(observation)
      observation_tensor = @model.prepare_input(observation)
      @model.forward(observation_tensor).first
    end

    def train(done)
      return if @replay_memory.size < MIN_REPLAY_MEMORY_SIZE

      minibatch = @replay_memory.sample(MINIBATCH_SIZE)
      current_states = minibatch.map(&:first)

      x = []
      y = Torch.zeros(MINIBATCH_SIZE, ACTION_SPACE.size)

      Torch.no_grad do
        current_qs_list = model.forward(model.prepare_input(current_states))

        new_current_states = minibatch.map { |t| t[3] }
        future_qs_list = model.forward(model.prepare_input(new_current_states))

        minibatch.each.with_index do |(current_state, action, reward, new_current_state, done), index|
          if done
            new_q = reward
          else
            max_future_q = future_qs_list[index].max
            new_q = reward + DISCOUNT * max_future_q.to_f
          end

          current_qs = current_qs_list[index]
          current_qs[action] = new_q

          x << current_state
          y[index] = current_qs
        end
      end

      loss = @model.fit(@model.prepare_input(x), y, @optimizer, @device)

      @target_update_counter += 1 if done

      if @target_update_counter > UPDATE_TARGET_EVERY
        @target_model.load_state_dict(@model.state_dict)
        @target_update_counter = 0
      end

      loss
    end
  end
end
