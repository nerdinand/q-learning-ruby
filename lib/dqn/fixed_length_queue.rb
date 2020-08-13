module DQN
  class FixedLengthQueue < Array
    def initialize(fixed_length)
      @fixed_length = fixed_length
    end

    def <<(item)
      super(item)

      shift if length > @fixed_length

      self
    end
  end
end
