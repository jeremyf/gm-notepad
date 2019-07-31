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
            "\t? - Help (this command)",
            "\t+ - Query table names and contents",
            "\t<table_name: - Write the results to the given table",
            "",
            "Tokens:",
            "\t! - Skip expansion",
            "\t/search/ - Grep for the given 'search' within the prefix",
            "\t[index] - Target a specific 'index'",
            "\t{table_name} - expand_line the given 'table_name'"
          ].each do |text|
            input.for_rendering(text: text, to_interactive: true, to_output: false, expand_line: false)
          end
        end
      end
    end
  end
end
