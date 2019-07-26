require_relative "default_handler"

module Gmshell
  module InputHandlers
    class WriteToTableHandler < DefaultHandler
      def self.handles?(input:)
        return true if input[0] == "<"
      end

      attr_accessor :index, :grep, :table_name, :line
      NON_EXPANDING_CHARATER = '!'.freeze
      WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
      WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
      WITH_WRITE_TARGET_REGEXP = %r{\A<(?<table_name>[^>]+)>(?<line>.*)}
      def after_initialize!
        if match = WITH_WRITE_TARGET_REGEXP.match(input)
          line = match[:line].strip
          table_name = match[:table_name]
          if index_match = WITH_INDEX_REGEXP.match(table_name)
            table_name = table_name.sub(index_match[:declaration], '')
            self.index = index_match[:index]
          elsif grep_match = WITH_GREP_REGEXP.match(table_name)
            table_name = table_name.sub(grep_match[:declaration], '')
            self.grep = grep_match[:grep]
          end
          self.table_name = table_name.downcase
        else
          raise "I don't know what to do"
        end
        if line[0] == NON_EXPANDING_CHARATER
          self.expand_line = false
          self.line = line[1..-1]
        else
          self.expand_line = true
        end
        self.line = line.strip
      end

      def lines
        if index
        elsif grep
        end
        if expand_line
        else
        end
        [line]
      end
    end
  end
end
