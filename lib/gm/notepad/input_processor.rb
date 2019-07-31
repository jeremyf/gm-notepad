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
        build_for(input: input)
      end

      private

      def build_for(input:)
        input_handler_registry.handler_for(input: input, table_registry: table_registry)
      end
    end
  end
end
