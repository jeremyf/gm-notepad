require "gm/notepad/input_handlers/default_handler"
module Gm
  module Notepad
    module InputHandlers
      class CommentHandler < DefaultHandler
        COMMENT_PREFIX = '#'.freeze

        def self.handles?(input:)
          return false unless input.match(/^#/)
          true
        end

        def after_initialize!
          self.to_interactive = true
          self.to_output = false
          self.expand_line = false
          input.for_rendering(text: input.original_text, to_interactive: true, to_output: false)
        end

        def lines
          input.lines_for_rendering
        end
      end
    end
  end
end
