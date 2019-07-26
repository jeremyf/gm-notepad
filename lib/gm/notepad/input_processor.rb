module Gm
  module Notepad
    # Responsible for processing the given input into a renderable state
    class InputProcessor
      def initialize(table_registry:, **config)
        self.table_registry = table_registry
        self.input_handler_registry = config.fetch(:input_handler_registry) { default_input_handler_registry }
      end

      def process(input:)
        processor = build_for(input: input)
        processor.each_line_with_parameters do |*args|
          yield(*args)
        end
      end

      attr_accessor :table_registry, :input_handler_registry
      private :table_registry=, :input_handler_registry

      private

      def build_for(input:)
        input = input.to_s.strip
        handler = input_handler_registry.handler_for(input: input)
        handler.table_registry = table_registry
        handler
      end

      def default_input_handler_registry
        require_relative "input_handler_registry"
        require_relative "input_handlers/help_handler"
        require_relative "input_handlers/query_table_handler"
        require_relative "input_handlers/query_table_names_handler"
        require_relative "input_handlers/write_to_table_handler"
        require_relative "input_handlers/write_line_handler"
        InputHandlerRegistry.new do |registry|
          registry.register(handler: InputHandlers::HelpHandler)
          registry.register(handler: InputHandlers::QueryTableHandler)
          registry.register(handler: InputHandlers::QueryTableNamesHandler)
          registry.register(handler: InputHandlers::WriteToTableHandler)
          registry.register(handler: InputHandlers::WriteLineHandler)
        end
      end
    end
  end
end
