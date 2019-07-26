require_relative 'input_handlers/default_handler'
module Gm
  module Notepad
    # Responsible for registering the various input handlers
    class InputHandlerRegistry
      def initialize
        @registry = []
        yield(self) if block_given?
      end

      def handler_for(input:, skip_default: false)
        handler = nil
        @registry.each do |handler_builder|
          if handler = handler_builder.build_if_handled(input: input)
            break
          end
        end
        return handler if handler
        return nil if skip_default
        default_handler_builder.build_if_handled(input: input)
      end

      def register(handler:)
        @registry << handler
      end

      def default_handler_builder
        InputHandlers::DefaultHandler
      end
    end
  end
end
