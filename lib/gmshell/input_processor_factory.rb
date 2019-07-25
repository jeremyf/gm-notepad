require_relative 'message_handlers/query_table_handler'
require_relative 'message_handlers/query_table_names_handler'
require_relative 'message_handlers/write_line_handler'
require_relative 'message_handlers/help_handler'

module Gmshell
  class InputProcessorFactory
    def initialize(table_registry:)
      self.table_registry = table_registry
      @parameter_factory = MessageHandlerParameterFactory.new
    end

    def build_for(input:)
      input = input.to_s.strip
      message_context = @parameter_factory.extract(input)
      InputProcessor.new(message_context: message_context, table_registry: table_registry)
    end

    HANDLERS = {
      query_table: Gmshell::MessageHandlers::QueryTableHandler,
      query_table_names: Gmshell::MessageHandlers::QueryTableNamesHandler,
      write_line: Gmshell::MessageHandlers::WriteLineHandler,
      help: Gmshell::MessageHandlers::HelpHandler
    }

    class InputProcessor
      attr_reader :message_context, :table_registry, :handler
      def initialize(message_context:, table_registry:)
        @message_context = message_context
        @table_registry = table_registry
        @handler = HANDLERS.fetch(message_context.handler_name)
      end

      def each_line_with_parameters
        lines = handler.call(registry: @table_registry, **message_context.parameters)
        Array(lines).each do |line|
          line = table_registry.evaluate(line: line.to_s.strip) if message_context.expand_line?
          yield(line, **message_context.parameters.slice(:to_output, :to_interactive))
        end
      end
    end

    private
    attr_accessor :table_registry
  end
end
