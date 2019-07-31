require 'gm/notepad/container'
require 'dry/configurable'
module Gm
  module Notepad
    # Responsible for processing the given input into a renderable state
    class InputProcessor
      extend Dry::Initializer
      option :table_registry, default: -> { Container.resolve(:table_registry) }
      option :input_handler_registry, default: -> { Container.resolve(:input_handler_registry) }

      def convert_to_output(input:)
        input = ThroughputText.new(original_text: input, table_registry: table_registry)
        build_for(input: input)
        input
      end

      private

      def build_for(input:)
        input_handler_registry.handler_for(input: input, table_registry: table_registry)
      end
    end
  end
end
