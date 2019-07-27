require 'gm/notepad/configuration'
module Gm
  module Notepad
    # Responsible for recording entries and then dumping them accordingly.
    class Pad
      Notepad::Configuration.init!(self, with: [:table_registry, :renderer, :input_processor]) do
        open!
      end

      def process(input:)
        input_processor.process(input: input) do |*args|
          renderer.call(*args)
        end
      end

      def close!
        renderer.close!
      end

      private

      def open!
        return unless config.report_config
        lines = ["# Configuration Parameters:"]
        config.each_pair do |key, value|
          lines << "#   config[#{key.inspect}] = #{value.inspect}"
        end
        # When running :list_tables by default I don't want to report
        # that to the output buffer.
        to_output = !config.list_tables
        renderer.call(lines, to_interactive: true, to_output: to_output)
      end
    end
  end
end
