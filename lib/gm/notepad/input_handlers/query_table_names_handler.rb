require "gm/notepad/input_handlers/default_handler"

module Gm
  module Notepad
    module InputHandlers
      class QueryTableNamesHandler < DefaultHandler
        QUERY_TABLE_NAMES_PREFIX = '+'.freeze
        def self.handles?(input:)
          # Does not have the table prefix
          return false unless input.match(/^\+/)
          # It is only the table prefix
          return true if input.match(/^\+$/)
          # It is querying all tables by way of grep
          return true if input.match(/^\+\//)
          false
        end

        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
        def after_initialize!
          grep = nil
          input.sub!(/^./,'')
          if match = input.match(WITH_GREP_REGEXP)
            input.sub!(match[:declaration], '')
            grep = match[:grep]
          end

          table_names = table_registry.table_names
          table_names = table_names.grep(%r{#{grep}}) if grep
          table_names.each do |table_name|
            input.render_current_text(text: table_name, to_interactive: true, to_output: false, expand_line: false)
          end
        end
      end
    end
  end
end
