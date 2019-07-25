module Gmshell
  class InputProcessingContext
    def initialize(input:, handler_name:, **parameters)
      self.input = input.clone
      self.handler_name = handler_name.freeze
      self.parameters = parameters.freeze
    end

    include Comparable
    def <=>(other)
      hash <=> other.hash
    end

    def hash
      [input, handler_name, parameters].hash
    end

    def expand_line?
      parameters[:expand_line]
    end

    def to_output
      parameters.fetch(:to_output) { false }
    end

    def to_interactive
      parameters.fetch(:to_interactive) { true }
    end

    attr_accessor :input, :handler_name, :parameters

    private :input=
    private :handler_name=
    private :parameters=
  end
end
