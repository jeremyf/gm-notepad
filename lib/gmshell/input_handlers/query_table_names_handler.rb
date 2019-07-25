require_relative "default_handler"

module Gmshell
  module InputHandlers
    class QueryTableNamesHandler < DefaultHandler
      QUERY_TABLE_NAMES_PREFIX = '+'.freeze
      def self.handles?(input:)
        # Does not have the table prefix
        return false unless input[0] == QUERY_TABLE_NAMES_PREFIX
        # It is only the table prefix
        return true if input == QUERY_TABLE_NAMES_PREFIX
        # It is querying all tables by way of grep
        return true if input[0..1] == "#{QUERY_TABLE_NAMES_PREFIX}/"
        false
      end

      def after_initialize!
        self.expand_line = false
        self.to_output = false
        self.to_interactive = true
      end

      WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
      def to_params
        line = input[1..-1]
        parameters = { expand_line: false }
        args = [:query_table_names, parameters]
        if match = WITH_GREP_REGEXP.match(line)
          line = line.sub(match[:declaration], '')
          grep = match[:grep]
          parameters[:grep] = grep
        end
        args
        parameters
      end

      def call(grep: false, registry:, **kwargs)
        table_names = registry.table_names
        return table_names unless grep
        table_names.grep(%r{#{grep}})
      end
    end
  end
end
