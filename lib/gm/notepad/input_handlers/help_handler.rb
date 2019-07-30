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
          self.to_interactive = true
          self.to_output = false
          self.expand_line = false
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
            input.for_rendering(text: text, to_interactive: to_interactive, to_output: to_output)
          end
        end
      end
    end
  end
end
