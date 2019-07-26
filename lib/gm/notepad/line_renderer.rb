require 'time'
module Gm
  module Notepad
    # Responsible for rendering lines to the corresponding buffers
    class LineRenderer
      def initialize(with_timestamp: false, defer_output:, output_buffer: default_output_buffer, interactive_buffer: default_interactive_buffer)
        @output_buffer = output_buffer
        @interactive_buffer = interactive_buffer
        @with_timestamp = with_timestamp
        @defer_output = defer_output
        @lines = []
        yield(self) if block_given?
      end

      def call(line, to_output: false, to_interactive: true, as_of: Time.now)
        render_output(line, defer_output: defer_output, as_of: as_of) if to_output
        render_interactive(line) if to_interactive
      end

      def close!
        if defer_output
          @lines.each do |line|
            output_buffer.puts(line)
          end
        end
      end

      private

      # When true, we defer_output writing until we close the notepad
      # When false, we write immediately to the output buffer
      attr_reader :defer_output

      # The receiver of interactive messages
      attr_reader :interactive_buffer

      # The receiver of output
      attr_reader :output_buffer

      # When writing to output_buffer, should we prefix with a timestamp?
      def with_timestamp?
        @with_timestamp
      end

      def render_output(line, defer_output:, as_of:)
        if with_timestamp?
          line = "#{as_of}\t#{line}"
        end
        if defer_output
          @lines << line
        else
          output_buffer.puts(line)
        end
      end

      def render_interactive(line)
        interactive_buffer.puts("=>\t#{line}")
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
