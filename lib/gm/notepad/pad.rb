module Gm
  module Notepad
    # Responsible for recording entries and then dumping them accordingly.
    class Pad
      attr_reader :config
      def initialize(**config)
        self.config = config
        self.table_registry = config.fetch(:table_registry) { default_table_registry }
        self.renderer = config.fetch(:renderer) { default_renderer }
        self.input_processor = config.fetch(:input_processor) { default_input_processor }
        open!
      end

      def process(input:)
        input_processor.process(input: input) do |*args|
          renderer.call(*args)
        end
      end

      def close!
        @renderer.close!
      end

      attr_reader :table_registry

      private

      attr_reader :renderer
      def open!
        return unless config[:report_config]
        lines = ["# Configuration Parameters:"]
        config.each_pair do |key, value|
          lines << "#   config[#{key.inspect}] = #{value.inspect}"
        end
        # When running :list_tables by default I don't want to report
        # that to the output buffer.
        to_output = !config[:list_tables]
        renderer.call(lines, to_interactive: true, to_output: to_output)
      end

      attr_accessor :renderer, :input_processor
      attr_writer :config, :table_registry

      def default_input_processor
        require "gm/notepad/input_processor"
        InputProcessor.new(table_registry: table_registry)
      end

      def default_table_registry
        require "gm/notepad/table_registry"
        TableRegistry.load_for(**config)
      end

      def default_renderer
        require 'gm/notepad/line_renderer'
        LineRenderer.new(
          with_timestamp: config.fetch(:with_timestamp, false),
          defer_output: config.fetch(:defer_output, false),
          output_buffer: config.fetch(:output_buffer, default_output_buffer),
          interactive_buffer: config.fetch(:interactive_buffer, default_interactive_buffer),
          **config
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
end
