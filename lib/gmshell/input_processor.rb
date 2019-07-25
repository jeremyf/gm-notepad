require_relative 'message_handlers/query_table_handler'
require_relative 'message_handlers/query_table_names_handler'
require_relative 'message_handlers/write_line_handler'
require_relative 'message_handlers/help_handler'

module Gmshell
  class InputProcessor
    def initialize(table_registry:, renderer:)
      self.table_registry = table_registry
      self.renderer = renderer
      @parameter_factory = MessageHandlerParameterFactory.new
    end

    def process(input:)
      processor = build_for(input: input)
      processor.each_line_with_parameters do |*args|
        renderer.call(*args)
      end
    end

    def build_for(input:)
      input = input.to_s.strip
      message_context = @parameter_factory.extract(input)
      Handler.new(message_context: message_context, table_registry: table_registry)
    end

    HANDLERS = {
      query_table: Gmshell::MessageHandlers::QueryTableHandler,
      query_table_names: Gmshell::MessageHandlers::QueryTableNamesHandler,
      write_line: Gmshell::MessageHandlers::WriteLineHandler,
      help: Gmshell::MessageHandlers::HelpHandler
    }

    class Handler
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
          yield(line, to_output: message_context.to_output, to_interactive: message_context.to_interactive)
        end
      end
    end

    attr_accessor :table_registry, :renderer
    private :table_registry=, :renderer=
  end
end
