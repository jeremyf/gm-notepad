require "gm/notepad/input_handlers/default_handler"
module Gm
  module Notepad
    module InputHandlers
      class HelpHandler < DefaultHandler
        HELP_PREFIX = '?'.freeze

        def self.handles?(input:)
          return false unless input.match(/^\?/)
          true
        end

        def after_initialize!
          [
            "Prefixes:",
            "\t?  - Help (this command)",
            "\t+  - Query table names and contents",
            "\t<table_name: - Write the results to the given table",
            "\t`  - Shell out command and write to interactive buffer",
            "\t`> - Shell out command and write to interactive AND output buffer",
            "",
            "Tokens:",
            "\t! - Skip expansion",
            "\t/search/ - Grep for the given 'search' within the prefix",
            "\t[index] - Target a specific 'index'",
            "\t[][column] - Pick a random index",
            "\t{table_name} - expand_line the given 'table_name'",
            "\t{table_name[d6]} - roll a d6 and lookup that row on the given 'table_name'",
            "\t{table_name[d6][name]} - pick a random row (between 1 and 6) and select the 'name' column from the given table_name"
          ].each do |text|
            input.for_rendering(text: text, to_interactive: true, to_output: false, expand_line: false)
          end
        end
      end
    end
  end
end
