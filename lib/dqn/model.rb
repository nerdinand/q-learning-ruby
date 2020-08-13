require 'torch'

require_relative '../agent'
require_relative '../environment'

module DQN
  class Model < Torch::NN::Module
    def initialize
      super
      @fc1 = Torch::NN::Linear.new(4, 128)
      @fc2 = Torch::NN::Linear.new(128, 64)
      @fc3 = Torch::NN::Linear.new(64, Agent::ACTION_SPACE.size)
    end

    def forward(x)
      x = @fc1.call(x)
      x = Torch::NN::F.relu(x)
      x = @fc2.call(x)
      x = Torch::NN::F.relu(x)
      x = @fc3.call(x)
      Torch::NN::F.log_softmax(x, 1)
    end

    def prepare_input(input)
      input = to_tensor(input)
      if input.shape.size == 1
        normalize(reshape_as_batch(input))
      elsif input.shape.size == 2
        normalize(input)
      else
        raise "Unexpected shape for input: #{input.shape}"
      end
    end

    def fit(data, target, optimizer, device)
      self.train
      data, target = data.to(device), target.to(device)
      optimizer.zero_grad
      output = self.call(data)
      loss = Torch::NN.mse_loss(output, target)
      loss.backward
      optimizer.step
      loss.to_f
    end

    def save(path)
      Torch.save(state_dict, path)
    end

    private

    def to_tensor(observation)
      Torch.tensor(observation)
    end

    def reshape_as_batch(tensor)
      tensor.reshape(-1, *tensor.shape) # reshape from [1.0, 2.0, 3.0, 4.0] to [[1.0, 2.0, 3.0, 4.0]]
    end

    def normalize(tensor)
      tensor / (Environment::SIZE - 1).to_f
    end
  end
end