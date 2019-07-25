require_relative "default_handler"
module Gmshell
  module InputHandlers
    class HelpHandler < DefaultHandler
      HELP_PREFIX = '?'.freeze

      def self.handles?(input:)
        return false unless input[0] == HELP_PREFIX
        true
      end

      def after_initialize!
        self.to_interactive = true
        self.to_output = false
        self.expand_line = false
      end

      def lines(**kwargs)
        [
          "Prefixes:",
          "\t? - Help (this command)",
          "\t+ - Query table names and contents",
          "\t<table_name> - Write the results to the given table",
          "",
          "Tokens:",
          "\t! - Skip expansion",
          "\t/search/ - Grep for the given 'search' within the prefix",
          "\t[index] - Target a specific 'index'",
          "\t{table_name} - expand_line the given 'table_name'"
        ]
      end
    end
  end
end
