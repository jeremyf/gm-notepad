require "gm/notepad/input_handlers/default_handler"

module Gm
  module Notepad
    module InputHandlers
      class WriteToTableHandler < DefaultHandler
        WITH_WRITE_TARGET_REGEXP = %r{\A\<(?<table_name>[^:]+):(?<line>.*)}
        def self.handles?(input:)
          return true if input.match(WITH_WRITE_TARGET_REGEXP)
        end

        def after_initialize!
          if match = input.match(WITH_WRITE_TARGET_REGEXP)
            input.text_to_evaluate = match[:line].strip
            table_name = match[:table_name]
            table_name = table_name.downcase
          else
            raise "I don't know what to do"
          end
          input.for_rendering(table_name: table_name, text: input.text_to_evaluate, to_interactive: true  , to_output: false, to_filesystem: true, expand_line: true)
        end
      end
    end
  end
end
