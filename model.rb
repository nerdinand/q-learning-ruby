require 'torch-rb'

module DQN
  class Model < Torch::NN::Module
    def initialize
      @fc = Torch::NN::Linear.new(4, 128)
    end
  end
end

m1 = DQN::Model.new
m2 = DQN::Model.new

m1.load_state_dict(m2.state_dict)
