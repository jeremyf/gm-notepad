require "gm/notepad/input_handlers/default_handler"
require "shellwords"
module Gm
  module Notepad
    module InputHandlers
      class ShellOutHandler < DefaultHandler
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
          command = input.to_s.split
          response = `#{command.shelljoin}`.strip

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
