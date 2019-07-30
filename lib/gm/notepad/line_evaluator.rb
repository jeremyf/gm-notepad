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

      TABLE_NAME_REGEXP = %r{(?<table_name_container>\{(?<table_name>[^\{\}]+)\})}
      def call(line:, expand_line: true)
        input = ThroughputText.new(original_text: line)
        return input unless expand_line
        parse_table(input: input)
        parse_dice(input: input)
        input
      end

      private

      def parse_table(input:)
        while match = input.match(TABLE_NAME_REGEXP)
          table_lookup = Parameters::TableLookup.new(text: match[:table_name].strip, roll_dice: true)
          entry = table_registry.lookup(**table_lookup.parameters)
          input.sub!(match[:table_name_container], entry)
        end
      end
      DICE_REGEXP = %r{(?<dice_container>\[(?<dice>[^\]]+)\])}
      def parse_dice(input:)
        while match = input.match(DICE_REGEXP)
          evaluated_dice = Evaluators::DiceEvaluator.call(text: match[:dice], fallback: "(#{match[:dice]})")
          input.sub!(match[:dice_container], evaluated_dice)
        end
      end
    end
  end
end
