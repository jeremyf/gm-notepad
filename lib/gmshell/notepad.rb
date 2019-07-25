require 'time'
require_relative 'message_handlers/query_table_handler'
require_relative 'message_handlers/query_table_names_handler'
require_relative 'message_handlers/write_line_handler'
require_relative 'message_handlers/help_handler'

module Gmshell
  # Responsible for recording entries and then dumping them accordingly.
  class Notepad
    attr_reader :config
    def initialize(**config)
      self.config = config
      self.table_registry = config.fetch(:table_registry) { default_table_registry }
      self.message_factory = config.fetch(:message_factory) { default_message_factory }
      self.renderer = config.fetch(:renderer) { default_renderer }
      start!
    end

    HANDLERS = {
      query_table: Gmshell::MessageHandlers::QueryTableHandler,
      query_table_names: Gmshell::MessageHandlers::QueryTableNamesHandler,
      write_line: Gmshell::MessageHandlers::WriteLineHandler,
      help: Gmshell::MessageHandlers::HelpHandler
    }

    HELP_REGEXP = /\A\?(?<help_with>.*)/
    def process(input:)
      message_context = message_factory.extract(input.to_s.strip)
      handler = HANDLERS.fetch(message_context.handler) { method(:record) }
      lines = handler.call(registry: table_registry, **message_context.parameters)
      log(lines, **message_context.parameters.slice(:to_output, :expand))
    end

    def record(line:, **kwargs)
      log(line, to_output: true, expand: true)
    end

    def log(lines, expand: true, to_output: false, to_interactive: true)
      Array(lines).each do |line|
        line = table_registry.evaluate(line: line.to_s.strip) if expand
        renderer.call(line, to_interactive: to_interactive, to_output: to_output)
      end
    end

    def fetch_table(*args)
      table_registry.fetch_table(*args)
    end

    def terms(*args)
      table_registry.terms(*args)
    end

    def dump!
      @renderer.dump!
    end

    attr_reader :table_registry

    private

    attr_reader :renderer
    def start!
      return if config[:skip_config_reporting]
      renderer.call("# Configuration Parameters:", to_interactive: true, to_output: true)
      config.each do |key, value|
        line = "#   config[#{key.inspect}] = #{value.inspect}"
        renderer.call(line, to_interactive: true, to_output: true)
      end
    end

    attr_accessor :message_factory, :renderer
    attr_writer :config, :table_registry

    def default_message_factory
      require_relative "message_handler_parameter_factory"
      MessageHandlerParameterFactory.new
    end

    def default_table_registry
      require_relative "table_registry"
      TableRegistry.load_for(paths: config.fetch(:paths, []))
    end

    def default_renderer
      require_relative 'line_renderer'
      @renderer = LineRenderer.new(
        with_timestamp: config.fetch(:with_timestamp, false),
        defer_output: config.fetch(:defer_output, false),
        output_buffer: config.fetch(:output_buffer, default_output_buffer),
        interactive_buffer: config.fetch(:interactive_buffer, default_interactive_buffer)
      )
    end

    def default_output_buffer
      $stdout
    end

    def default_interactive_buffer
      $stderr
    end
  end
end
