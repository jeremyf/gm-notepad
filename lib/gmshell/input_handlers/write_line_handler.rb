require_relative "default_handler"

module Gmshell
  module InputHandlers
    class WriteLineHandler < DefaultHandler
      NON_EXPANDING_CHARATER = '!'.freeze
      def self.handles?(input:)
        true
      end

      attr_accessor :line
      def after_initialize!
        self.expand_line = false
        self.to_output = true
        self.to_interactive = true
        if input[0] == NON_EXPANDING_CHARATER
          self.line = input[1..-1].strip
          self.expand_line = false
        else
          self.line = input.strip
          self.expand_line = true
        end
      end

      def lines
        [line]
      end
    end
  end
end
