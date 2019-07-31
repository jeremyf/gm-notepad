require "gm/notepad/input_handlers/default_handler"

module Gm
  module Notepad
    module InputHandlers
      class WriteLineHandler < DefaultHandler
        NON_EXPANDING_CHARATER = '!'.freeze
        def self.handles?(input:)
          true
        end

        def after_initialize!
          if input[0] == NON_EXPANDING_CHARATER
            input.sub!(/^\!/,'')
            expand_line = false
          else
            expand_line = true
          end
          input.render_current_text(to_interactive: true, to_output: true, expand_line: expand_line)
        end
      end
    end
  end
end
