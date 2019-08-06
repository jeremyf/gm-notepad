require "gm/notepad/input_handlers/default_handler"
module Gm
  module Notepad
    module InputHandlers
      # Responsible for handling shell out commands
      class ShellOutHandler < DefaultHandler
        option :shell_handler, default: -> { Container.resolve(:shell_handler) }

        SHELL_OUT_HANDLER_REGEXP = /^`/.freeze
        TO_OUTPUT_REGEXP = /^\>/.freeze

        def self.handles?(input:)
          return false unless input.match(SHELL_OUT_HANDLER_REGEXP)
          true
        end

        def after_initialize!
          input.sub!(SHELL_OUT_HANDLER_REGEXP,'')
          if input.match(TO_OUTPUT_REGEXP)
            input.sub!(TO_OUTPUT_REGEXP, '')
            to_output = true
          else
            to_output = false
          end
          response = shell_handler.call(input)

          input.for_rendering(
            text: response,
            to_interactive: true,
            to_output: to_output,
            expand_line: false
          )
        end
      end
    end
  end
end
