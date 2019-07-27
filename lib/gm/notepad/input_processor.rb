require 'gm/notepad/configuration'
module Gm
  module Notepad
    # Responsible for processing the given input into a renderable state
    class InputProcessor
      Configuration.init!(target: self, from_config: [:table_registry, :input_handler_registry])

      def process(input:)
        processor = build_for(input: input)
        processor.each_line_with_parameters do |*args|
          yield(*args)
        end
      end

      private

      def build_for(input:)
        input = input.to_s.strip
        handler = input_handler_registry.handler_for(input: input)
        handler.table_registry = table_registry
        handler
      end
    end
  end
end
