require 'gm/notepad/configuration'
require 'time'
require 'term/ansicolor'
module Gm
  module Notepad
    # Responsible for rendering lines to the corresponding buffers
    class LineRenderer
      Configuration.init!(target: self, from_config: [:with_timestamp, :defer_output, :output_buffer, :interactive_buffer]) do
        @lines = []
        yield(self) if block_given?
      end

      def call(lines, to_output: false, to_interactive: true, as_of: Time.now)
        render_interactive(lines) if to_interactive
        render_output(lines, defer_output: config[:defer_output], as_of: as_of) if to_output
      end

      def close!
        interactive_buffer.close!
        output_buffer.close!
      end

      private

      def interactive_buffer=(buffer)
        if config[:interactive_color]
          @interactive_buffer = BufferWrapper.new(buffer, color: :faint, as: :interactive)
        else
          @interactive_buffer = BufferWrapper.new(buffer, as: :interactive)
        end
      end

      def output_buffer=(buffer)
        if config[:output_color]
          @output_buffer = BufferWrapper.new(buffer, color: :bold, as: :output)
        else
          @output_buffer = BufferWrapper.new(buffer, as: :output)
        end
      end

      def render_output(lines, defer_output:, as_of:)
        each_expanded_line(lines: lines) do |line|
          if config[:with_timestamp]
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
        each_expanded_line(lines: lines) do |line|
          interactive_buffer.puts("=>\t#{line}")
        end
      end

      # Gracefully expand the \t and \n for the output buffer
      def each_expanded_line(lines:)
        Array(lines).each do |unexpanded_line|
          unexpanded_line.to_s.split('\\n').each do |line|
            line = line.gsub('\\t', "\t")
            yield(line)
          end
        end
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
