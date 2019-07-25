require_relative "default_handler"

module Gmshell
  module InputHandlers
    class WriteLineHandler < DefaultHandler
      NON_EXPANDING_CHARATER = '!'.freeze
      def self.handles?(input:)
        true
      end

      def to_params
        line = input
        if line[0] == NON_EXPANDING_CHARATER
          [:write_line, line: line[1..-1].strip, expand_line: false, to_output: true]
        else
          [:write_line, line: line.strip, expand_line: true, to_output: true]
        end
      end
      def self.call(line:, **kwargs)
        line
      end
    end
  end
end
