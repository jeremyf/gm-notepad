require_relative 'input_handlers/query_table_handler'
require_relative 'input_handlers/query_table_names_handler'
require_relative 'input_handlers/write_line_handler'
require_relative 'input_handlers/help_handler'
require_relative 'message_handler_parameter_factory'

module Gmshell
  class InputProcessor
    def initialize(table_registry:)
      self.table_registry = table_registry
      @parameter_factory = MessageHandlerParameterFactory.new
    end

    def process(input:)
      processor = build_for(input: input)
      processor.each_line_with_parameters do |*args|
        yield(*args)
      end
    end

    attr_accessor :table_registry
    private :table_registry=

    private

    def build_for(input:)
      input = input.to_s.strip
      input_processing_context = @parameter_factory.extract(input)
      Handler.new(input_processing_context: input_processing_context, table_registry: table_registry)
    end

    HANDLERS = {
      query_table: Gmshell::InputHandlers::QueryTableHandler,
      query_table_names: Gmshell::InputHandlers::QueryTableNamesHandler,
      write_line: Gmshell::InputHandlers::WriteLineHandler,
      help: Gmshell::InputHandlers::HelpHandler
    }

    class Handler
      attr_reader :input_processing_context, :table_registry, :handler
      def initialize(input_processing_context:, table_registry:)
        @input_processing_context = input_processing_context
        @table_registry = table_registry
        @handler = HANDLERS.fetch(input_processing_context.handler_name)
      end

      def each_line_with_parameters
        lines = handler.call(registry: table_registry, **input_processing_context.parameters)
        Array(lines).each do |line|
          line = table_registry.evaluate(line: line.to_s.strip) if input_processing_context.expand_line?
          yield(line, to_output: input_processing_context.to_output, to_interactive: input_processing_context.to_interactive)
        end
      end
    end
  end
end
