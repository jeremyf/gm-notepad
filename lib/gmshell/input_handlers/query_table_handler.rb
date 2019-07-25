require_relative "default_handler"
module Gmshell
  module InputHandlers
    class QueryTableHandler < DefaultHandler
      QUERY_TABLE_NAMES_PREFIX = '+'.freeze
      def self.handles?(input:)
        # Does not have the table prefix
        return false unless input[0] == QUERY_TABLE_NAMES_PREFIX
        # It is only the table prefix
        return false if input == QUERY_TABLE_NAMES_PREFIX
        # It is querying all tables by way of grep
        return false if input[0..1] == "#{QUERY_TABLE_NAMES_PREFIX}/"
        true
      end

      def after_initialize!
        self.expand_line = false
        self.to_output = false
        self.to_interactive = true
      end

      WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
      WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
      NON_EXPANDING_CHARATER = '!'.freeze
      def to_params
        line = input[1..-1]
        parameters = {expand_line: false }
        if match = WITH_INDEX_REGEXP.match(line)
          line = line.sub(match[:declaration], '')
          index = match[:index]
          parameters[:index] = index
        elsif match = WITH_GREP_REGEXP.match(line)
          line = line.sub(match[:declaration], '')
          grep = match[:grep]
          parameters[:grep] = grep
        end
        if line[-1] == NON_EXPANDING_CHARATER
          line = line[0..-2]
        end
        parameters[:table_name] = line.downcase
        parameters
      end

      def call(registry:, table_name:, index: nil, grep: false, **kwargs)
        begin
          table = registry.fetch_table(name: table_name)
        rescue KeyError
          message = "Unknown table #{table_name.inspect}. Did you mean: "
          message += registry.table_names.grep(/\A#{table_name}/).map(&:inspect).join(", ")
          return [message]
        end
        if index
          [table.lookup(index: index)]
        elsif grep
          regexp = %r{#{grep}}i
          table.grep(regexp)
        else
          table.all
        end
      end
    end
  end
end
