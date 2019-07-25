module Gmshell
  module MessageHandlers
    module HelpHandler
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
