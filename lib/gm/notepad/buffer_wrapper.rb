require 'dry-initializer'
require 'term/ansicolor'
require 'gm/notepad/container'

module Gm
  module Notepad
    # To provide a means for colorizing the output and defering output
    class BufferWrapper
      def self.for_interactive(buffer:)
        new(buffer: buffer, color: Container[:config].interactive_color, append_new_line_on_close: true)
      end

      def self.for_output(buffer:)
        new(buffer: buffer, color: Container[:config].output_color, append_new_line_on_close: false)
      end
      private_class_method :new

      extend Dry::Initializer
      option :buffer
      option :color, default: -> { false }
      option :append_new_line_on_close, default: -> { false }
      option :lines, default: -> { [] }

      def initialize(*args)
        super
        if color
          buffer.extend(Term::ANSIColor)
        end
      end

      def puts(text)
        if color
          buffer.puts("#{buffer.public_send(color)}#{text}#{buffer.reset}")
        else
          buffer.puts("#{text}")
        end
      end

      def defer(line)
        self.lines << line
      end

      def close!
        self.lines.each do |line|
          puts(line)
        end
        buffer.print("\n") if append_new_line_on_close
      end
    end
  end
end
