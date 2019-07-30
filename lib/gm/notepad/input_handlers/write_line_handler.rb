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
          self.expand_line = false
          self.to_output = true
          self.to_interactive = true
          if input[0] == NON_EXPANDING_CHARATER
            input.sub!(/^\!/,'')
            self.expand_line = false
          else
            self.expand_line = true
          end
          input.render_current_text(to_interactive: true, to_output: false)
        end
      end
    end
  end
end
