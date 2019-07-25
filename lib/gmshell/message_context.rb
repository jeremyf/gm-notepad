module Gmshell
  class MessageContext
    def initialize(input:, handler:, **parameters)
      self.input = input.freeze
      self.handler = handler.freeze
      self.parameters = parameters.freeze
    end

    include Comparable
    def <=>(other)
      hash <=> other.hash
    end

    def hash
      [input, handler, parameters].hash
    end

    attr_accessor :input, :handler, :parameters

    private :input=
    private :handler=
    private :parameters=
  end
end
