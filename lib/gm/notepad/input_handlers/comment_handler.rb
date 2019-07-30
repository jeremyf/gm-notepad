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
          input.for_rendering(
            text: input.original_text,
            to_interactive: true,
            to_output: false,
            expand_line: false
          )
        end
      end
    end
  end
end
