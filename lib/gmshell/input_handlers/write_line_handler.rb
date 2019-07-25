require_relative "default_handler"

module Gmshell
  module InputHandlers
    class WriteLineHandler < DefaultHandler
      NON_EXPANDING_CHARATER = '!'.freeze
      def self.handles?(input:)
        true
      end

      def after_initialize!
        self.expand_line = false
        self.to_output = true
        self.to_interactive = true
      end

      def to_params
        line = input
        if line[0] == NON_EXPANDING_CHARATER
          self.expand_line = false
          { line: line[1..-1].strip, expand_line: false, to_output: true }
        else
          self.expand_line = true
          { line: line.strip, expand_line: true, to_output: true }
        end
      end
      def call(line:, **kwargs)
        line
      end
    end
  end
end
