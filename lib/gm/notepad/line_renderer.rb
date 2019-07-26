require 'time'
require 'term/ansicolor'
module Gm
  module Notepad
    # Responsible for rendering lines to the corresponding buffers
    class LineRenderer
      def initialize(defer_output:, output_buffer: default_output_buffer, interactive_buffer: default_interactive_buffer, **config)
        self.config = config
        self.output_buffer = output_buffer
        self.interactive_buffer = interactive_buffer
        @defer_output = defer_output
        @lines = []
        yield(self) if block_given?
      end

      def call(lines, to_output: false, to_interactive: true, as_of: Time.now)
        render_interactive(lines) if to_interactive
        render_output(lines, defer_output: defer_output, as_of: as_of) if to_output
      end

      def close!
        interactive_buffer.close!
        output_buffer.close!
      end

      private

      attr_accessor :config

      # When true, we defer_output writing until we close the notepad
      # When false, we write immediately to the output buffer
      attr_reader :defer_output

      # The receiver of interactive messages
      attr_reader :interactive_buffer

      def interactive_buffer=(buffer)
        if config[:interactive_color]
          @interactive_buffer = BufferWrapper.new(buffer, color: :faint, as: :interactive)
        else
          @interactive_buffer = BufferWrapper.new(buffer, as: :interactive)
        end
      end

      # The receiver of output
      attr_reader :output_buffer

      def output_buffer=(buffer)
        if config[:output_color]
          @output_buffer = BufferWrapper.new(buffer, color: :bold, as: :output)
        else
          @output_buffer = BufferWrapper.new(buffer, as: :output)
        end
      end


      # When writing to output_buffer, should we prefix with a timestamp?
      def with_timestamp?
        config.fetch(:with_timestamp, false)
      end

      def render_output(lines, defer_output:, as_of:)
        Array(lines).each do |line|
          if with_timestamp?
            line = "#{as_of}\t#{line}"
          end
          if defer_output
            output_buffer.defer(line)
          else
            output_buffer.puts(line)
          end
        end
      end

      def render_interactive(lines)
        Array(lines).each do |line|
          interactive_buffer.puts("=>\t#{line}")
        end
      end

      def default_output_buffer
        $stdout
      end

      def default_interactive_buffer
        $stderr
      end
    end

    # To provide a means for colorizing the output
    class BufferWrapper
      attr_reader :buffer, :color, :as
      def initialize(buffer, color: false, as:)
        @buffer = buffer
        @buffer.extend(Term::ANSIColor)
        @color = color
        @as = as
        @lines = []
      end

      def puts(text)
        if color
          buffer.puts("#{buffer.public_send(color)}#{text}#{buffer.reset}")
        else
          buffer.puts("#{text}")
        end
      end

      def defer(line)
        @lines << line
      end

      def close!
        buffer.print("\n") if as == :interactive
        @lines.each do |line|
          puts(line)
        end
      end
    end
    private_constant :BufferWrapper
  end
end
