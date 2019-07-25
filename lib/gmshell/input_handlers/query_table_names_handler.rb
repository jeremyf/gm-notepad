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

      WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
      def after_initialize!
        self.expand_line = false
        self.to_output = false
        self.to_interactive = true

        line = input[1..-1]
        if match = WITH_GREP_REGEXP.match(line)
          line = line.sub(match[:declaration], '')
          self.grep = match[:grep]
        end
      end

      attr_accessor :grep

      def lines(**kwargs)
        call(**kwargs)
      end

      def call(**kwargs)
        table_names = table_registry.table_names
        return table_names unless grep
        table_names.grep(%r{#{grep}})
      end
    end
  end
end
