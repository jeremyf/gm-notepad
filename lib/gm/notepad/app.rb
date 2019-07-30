require 'dry-initializer'
require 'gm/notepad/container'

module Gm
  module Notepad
    # Responsible for recording entries and then dumping them accordingly.
    class App
      extend Dry::Initializer
      option :renderer, default: -> { Container.resolve(:renderer) }
      option :input_processor, default: -> { Container.resolve(:input_processor) }
      option :report_config, default: -> { Container.resolve(:config).report_config }, reader: :private
      option :list_tables, default: -> { Container.resolve(:config).list_tables }, reader: :private

      def initialize(*args)
        super
        open!
      end

      def process(text:)
        input = ThroughputText.new(original_text: text)
        input_processor.process(input: input) do |*args|
          renderer.call(*args)
        end
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
