require 'dry-initializer'
module Gm
  module Notepad
    # Keep the original text close to the text that we are changing.
    # This way we can dump the original text as a comment.
    class ThroughputText
      extend Dry::Initializer
      option :original_text, proc(&:strip)
      option :table_registry, default: -> { Container.resolve(:table_registry) }, reader: :private
      option :lines_for_rendering, default: -> { [] }, reader: :private
      def initialize(*args)
        super
        self.text_to_evaluate = original_text.strip
        original_text.freeze
      end

      attr_reader :text_to_evaluate

      def match(regexp)
        text_to_evaluate.match(regexp)
      end

      def sub!(from, to)
        @text_to_evaluate = text_to_evaluate.sub(from, to)
      end

      def [](*args)
        @text_to_evaluate[*args]
      end

      def to_str
        @text_to_evaluate.to_str
      end

      def to_s
        @text_to_evaluate.to_s
      end

      attr_writer :text_to_evaluate

      def for_rendering(text:, **kwargs)
        @lines_for_rendering << LineForRendering.new(text: text, table_registry: table_registry, **kwargs)
      end

      def render_current_text(**kwargs)
        for_rendering(text: text_to_evaluate, **kwargs)
      end

      def evaluate!
        lines_for_rendering.each do |line|
          line.expand!
        end
      end

      def lines_for_rendering
        @lines_for_rendering
      end

      alias lines lines_for_rendering
    end

    class LineForRendering
      extend Dry::Initializer
      option :text, proc(&:to_s)
      option :to_interactive
      option :to_output
      option :to_filesystem, default: -> { false }
      option :expand_line, default: -> { true }
      option :table_registry, default: -> { Container.resolve(:table_registry) }, reader: :private

      alias to_s text
      alias to_str text

      def expand!
        return false unless expand_line
        instance_variable_set("@text", table_registry.evaluate(line: text).to_s)
      end
    end
  end
end
