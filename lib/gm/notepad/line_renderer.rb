require 'time'
require 'dry-initializer'
require 'gm/notepad/container'
require 'gm/notepad/buffer_wrapper'

module Gm
  module Notepad
    # Responsible for rendering lines to the corresponding buffers
    class LineRenderer
      extend Dry::Initializer
      option :with_timestamp, default: -> { Container[:config].with_timestamp }
      option :defer_output, default: -> { Container[:config].defer_output }
      option :interactive_buffer, type: -> (buffer, renderer) { BufferWrapper.for_interactive(buffer: buffer) }, default: -> { Container[:config].interactive_buffer }
      option :output_buffer, type: -> (buffer, renderer) { BufferWrapper.for_output(buffer: buffer) }, default: -> { Container[:config].output_buffer }

      def render(output:, as_of: Time.now)
        output.evaluate!
        output.lines_for_rendering.each do |line|
          next unless line.to_interactive
          render_interactive(line)
        end
        output.lines_for_rendering.each do |line|
          next unless line.to_output
          render_output(line, defer_output: defer_output, as_of: as_of)
        end
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

      def render_output(lines, defer_output:, as_of:)
        each_expanded_line(lines: lines) do |line|
          if with_timestamp
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
          String(unexpanded_line).split('\\n').each do |line|
            line = line.gsub('\\t', "\t")
            yield(line)
          end
        end
      end
    end
  end
end
