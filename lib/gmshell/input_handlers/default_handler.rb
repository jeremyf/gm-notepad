module Gmshell
  module InputHandlers
    class DefaultHandler
      def self.build_if_handled(input:)
        return false unless handles?(input: input)
        new(input: input)
      end

      def self.handles?(input:)
        true
      end

      def initialize(input:)
        self.to_interactive = false
        self.to_output = false
        self.expand_line = false
        self.input = input
      end
      attr_accessor :table_registry, :to_interactive, :to_output, :expand_line, :input

      def to_params
      end
    end
  end
end
