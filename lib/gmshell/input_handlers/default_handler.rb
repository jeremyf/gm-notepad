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
        after_initialize!
      end
      attr_accessor :table_registry, :to_interactive, :to_output, :expand_line, :input

      def after_initialize!
      end

      def to_params
        { to_output: false }
      end

      def call
        []
      end

      alias expand_line? expand_line

      def each_line_with_parameters
        lines = call(registry: table_registry, **to_params)
        Array(lines).each do |line|
          line = table_registry.evaluate(line: line.to_s.strip) if expand_line?
          yield(line, to_output: to_output, to_interactive: to_interactive)
        end
      end
    end
  end
end
