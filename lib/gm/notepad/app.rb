require 'dry-initializer'
require 'gm/notepad/container'
require 'gm/notepad/line_renderer'
require 'gm/notepad/throughput_text'
require 'gm/notepad/input_processor'

module Gm
  module Notepad
    # Responsible for recording entries and then dumping them accordingly.
    class App
      extend Dry::Initializer
      option :table_registry, default: -> { Container.resolve(:table_registry) }, reader: :private
      option :report_config, default: -> { Container.resolve(:config).report_config }, reader: :private
      option :list_tables, default: -> { Container.resolve(:config).list_tables }, reader: :private

      def initialize(*args, input_processor: nil, renderer: nil)
        super
        # Note: I could note use Dry::Initializer.option with Container as I ended
        # up with multiple table registry objects created. Which is why I'm using the
        # keyword's with nil, so I can set two elements after the table_registry is "resolved"
        @renderer = renderer || LineRenderer.new(table_registry: table_registry)
        @input_processor = input_processor || InputProcessor.new(table_registry: table_registry)
        open!
      end
      attr_reader :renderer, :input_processor

      def process(text:)
        output = input_processor.convert_to_output(input: text)
        renderer.render(output: output)
      end

      def close!
        renderer.close!
      end

      private

      def open!
        renderer.call("Welcome to gm-notepad. type \"?\" for help.", to_interactive: true, to_output: false)
        return unless report_config
        lines = ["# Configuration Parameters:"]
        Config.settings.each do |setting|
          lines << "#   config[#{setting.inspect}] = #{Config.public_send(setting).inspect}"
        end
        # When running :list_tables by default I don't want to report
        # that to the output buffer.
        to_output = !list_tables
        renderer.call(lines, to_interactive: true, to_output: to_output)
      end
    end
  end
end
