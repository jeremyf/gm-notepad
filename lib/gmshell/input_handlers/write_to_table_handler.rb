module Gmshell
  module InputHandlers
    module WriteToTableHandler
      def self.handles?(input:)
        return true if input[0] == "<"
      end
      NON_EXPANDING_CHARATER = '!'.freeze
      WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
      WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
      WITH_WRITE_TARGET_REGEXP = %r{\A<(?<table_name>[^>]+)>(?<line>.*)}
      def self.to_params(input:)
        line = input
        parameters = {}
        args = [:write_to_table, parameters]
        if match = WITH_WRITE_TARGET_REGEXP.match(line)
          line = match[:line].strip
          table_name = match[:table_name]
          if index_match = WITH_INDEX_REGEXP.match(table_name)
            table_name = table_name.sub(index_match[:declaration], '')
            index = index_match[:index]
            parameters[:index] = index
          elsif grep_match = WITH_GREP_REGEXP.match(table_name)
            table_name = table_name.sub(grep_match[:declaration], '')
            parameters[:grep] = grep_match[:grep]
          end
          parameters[:table_name] = table_name.downcase
        else
          raise "I don't know what to do"
        end
        if line[0] == NON_EXPANDING_CHARATER
          parameters[:expand_line] = false
          line = line[1..-1]
        else
          parameters[:expand_line] = true
        end
        parameters[:line] = line.strip
        args
      end

      def self.call(table_name:, line:, registry:, index: nil, expand_line: false, grep: nil)
        if index
        elsif grep
        end
        if expand_line
        else
        end
      end
    end
  end
end
