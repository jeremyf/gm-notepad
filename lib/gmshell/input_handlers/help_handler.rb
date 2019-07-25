module Gmshell
  module InputHandlers
    module HelpHandler
      HELP_PREFIX = '?'.freeze

      def self.handles?(input:)
        return false unless input[0] == HELP_PREFIX
        true
      end

      # An interstitial method for splicing in changes
      def self.to_params(*)
        [:help, { expand_line: false }]
      end

      def self.call(**kwargs)
        lines = [
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
