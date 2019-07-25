require_relative "input_processing_context"
require_relative "input_handler_registry"
require_relative "input_handlers/help_handler"
require_relative "input_handlers/query_table_handler"
require_relative "input_handlers/query_table_names_handler"
require_relative "input_handlers/write_to_table_handler"
require_relative "input_handlers/write_line_handler"
module Gmshell
  # Responsible for extracting the appropriate message to send based
  # on the given line.
  class MessageHandlerParameterFactory
    def initialize
      @input_handler_registry = InputHandlerRegistry.new
      @input_handler_registry.register(handler: InputHandlers::HelpHandler)
      @input_handler_registry.register(handler: InputHandlers::QueryTableHandler)
      @input_handler_registry.register(handler: InputHandlers::QueryTableNamesHandler)
      @input_handler_registry.register(handler: InputHandlers::WriteToTableHandler)
      @input_handler_registry.register(handler: InputHandlers::WriteLineHandler)
    end

    def extract(input)
      response = call(line: input.clone)
      InputProcessingContext.new(input: input, handler_name: response[0], **response[1])
    end

    def call(line:)
      line = line.strip
      handler = @input_handler_registry.handler_for(input: line, skip_default: true)
      handler.to_params
    end
  end
end
