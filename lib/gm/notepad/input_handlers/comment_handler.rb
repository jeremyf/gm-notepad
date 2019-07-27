require "gm/notepad/input_handlers/default_handler"
module Gm
  module Notepad
    module InputHandlers
      class CommentHandler < DefaultHandler
        COMMENT_PREFIX = '#'.freeze

        def self.handles?(input:)
          return false unless input[0] == COMMENT_PREFIX
          true
        end

        def after_initialize!
          self.to_interactive = true
          self.to_output = false
          self.expand_line = false
        end

        def lines
          [input]
        end
      end
    end
  end
end
