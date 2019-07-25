module Gmshell
  # Responsible for recording entries and then dumping them accordingly.
  class Notepad
    attr_reader :config
    def initialize(**config)
      self.config = config
      self.table_registry = config.fetch(:table_registry) { default_table_registry }
      self.renderer = config.fetch(:renderer) { default_renderer }
      self.input_processor = config.fetch(:input_processor) { default_input_processor }
      open!
    end

    def process(input:)
      input_processor.process(input: input)
    end

    def close!
      @renderer.close!
    end

    attr_reader :table_registry

    private

    attr_reader :renderer
    def open!
      return if config[:skip_config_reporting]
      renderer.call("# Configuration Parameters:", to_interactive: true, to_output: true)
      config.each do |key, value|
        line = "#   config[#{key.inspect}] = #{value.inspect}"
        renderer.call(line, to_interactive: true, to_output: true)
      end
    end

    attr_accessor :renderer, :input_processor
    attr_writer :config, :table_registry

    def default_input_processor
      require_relative "input_processor"
      InputProcessor.new(table_registry: table_registry, renderer: renderer)
    end

    def default_table_registry
      require_relative "table_registry"
      TableRegistry.load_for(paths: config.fetch(:paths, []))
    end

    def default_renderer
      require_relative 'line_renderer'
      LineRenderer.new(
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
