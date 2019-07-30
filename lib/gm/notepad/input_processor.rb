require 'gm/notepad/container'
require 'dry/configurable'
module Gm
  module Notepad
    # Responsible for processing the given input into a renderable state
    class InputProcessor
      extend Dry::Initializer
      option :table_registry, default: -> { Container.resolve(:table_registry) }
      option :input_handler_registry, default: -> { Container.resolve(:input_handler_registry) }

      def process(input:)
        processor = build_for(input: input)
        processor.each_line_with_parameters do |*args|
          yield(*args)
        end
      end

      private

      def build_for(input:)
        handler = input_handler_registry.handler_for(input: input)
        handler.table_registry = table_registry
        handler
      end
    end
  end
end
