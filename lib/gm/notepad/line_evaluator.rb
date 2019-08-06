require 'dice'
require 'dry-initializer'
require 'gm/notepad/container'
require 'gm/notepad/parameters/table_lookup'
require 'gm/notepad/throughput_text'
require 'gm/notepad/evaluators/dice_evaluator'
module Gm
  module Notepad
    # Responsible for recording entries and then dumping them accordingly.
    class LineEvaluator
      extend Dry::Initializer
      option :table_registry, default: -> { Container.resolve(:table_registry) }, reader: :private
      option :time_to_live, default: -> { Container.resolve(:config).time_to_live }, reader: :private

      def call(line:, expand_line: true)
        input = ThroughputText.new(original_text: line, table_registry: table_registry)
        return input unless expand_line
        parse(input: input)
        input
      end

      private

      TEXT_TO_EXPAND_REGEXP = %r{(?<text_container>\{(?<text>[^\{\}]+)\})}
      def parse(input:)
        lives = 0
        while match = input.match(TEXT_TO_EXPAND_REGEXP)
          lives += 1
          if lives > time_to_live
            raise ExceededTimeToLiveError.new(text: input.original_text, time_to_live: time_to_live, text_when_time_to_live_exceeded: input.to_s)
          end
          rolled_text = Evaluators::DiceEvaluator.call(text: match[:text])
          # We sent the text through a dice roller. It came back unchanged, therefore
          # the text is not a dice expression. Now expand the table.
          if rolled_text == match[:text]
            table_lookup = Parameters::TableLookup.new(text: match[:text], roll_dice: true)
            entry = table_registry.lookup(**table_lookup.parameters)
            input.sub!(match[:text_container], entry)
          else
            input.sub!(match[:text_container], rolled_text)
          end
        end
      end
    end
  end
end
