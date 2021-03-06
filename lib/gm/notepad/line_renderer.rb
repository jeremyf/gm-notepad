require 'time'
require 'dry-initializer'
require 'dry-types'
require 'gm/notepad/container'
require 'gm/notepad/buffer_wrapper'

module Gm
  module Notepad
    # Responsible for rendering lines to the corresponding buffers
    class LineRenderer
      extend Dry::Initializer
      option :with_timestamp, default: -> { Container[:config].with_timestamp }
      option :interactive_buffer, type: -> (buffer, renderer) { BufferWrapper.for_interactive(buffer: buffer) }, default: -> { Container[:config].interactive_buffer }
      option :output_buffer, type: -> (buffer, renderer) { BufferWrapper.for_output(buffer: buffer) }, default: -> { Container[:config].output_buffer }
      option :table_registry, default: -> { Container.resolve(:table_registry) }

      def render(output:, as_of: Time.now)
        output.evaluate!
        output.lines_for_rendering.each do |line|
          next unless line.to_interactive
          render_interactive(line)
        end
        output.lines_for_rendering.each do |line|
          next unless line.to_output
          render_output(line, as_of: as_of)
        end
        output.lines_for_rendering.each do |line|
          next unless line.to_filesystem
          render_filesystem(line)
        end
      end

      def call(lines, to_output: false, to_interactive: true, as_of: Time.now)
        render_interactive(lines) if to_interactive
        render_output(lines, as_of: as_of) if to_output
      end

      def close!
        interactive_buffer.close!
        output_buffer.close!
      end

      private

      def render_output(lines, as_of:)
        each_expanded_line(lines: lines) do |line|
          if with_timestamp
            line = "#{as_of}\t#{line}"
          end
          output_buffer.puts(line)
        end
      end

      def render_interactive(lines)
        each_expanded_line(lines: lines) do |line|
          interactive_buffer.puts(line)
        end
      end

      def render_filesystem(lines)
        return unless lines.table_name
        table_name = lines.table_name
        each_expanded_line(lines: lines) do |line|
          table_registry.append(table_name: table_name, line: line, write: true)
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
