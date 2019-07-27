require 'dice'
require 'gm/notepad/parameters/table_lookup'
require 'gm/notepad/evaluators/dice_evaluator'
module Gm
  module Notepad
    # Responsible for recording entries and then dumping them accordingly.
    class LineEvaluator
      def initialize(table_registry:)
        @table_registry = table_registry
      end
      attr_reader :table_registry

      TABLE_NAME_REGEXP = %r{(?<table_name_container>\{(?<table_name>[^\{\}]+)\})}
      def call(line:, expand_line: true)
        return line unless expand_line
        text = parse_table(text: line)
        parse_dice(text: text)
      end

      private

      def parse_table(text:)
        while match = text.match(TABLE_NAME_REGEXP)
          table_lookup = Parameters::TableLookup.new(text: match[:table_name].strip)
          if table_lookup.index
            table_lookup.index = Evaluators::DiceEvaluator.call(text: table_lookup.index)
            entry = table_registry.lookup(index: table_lookup.index, table_name: table_lookup.table_name)
          else
            entry = table_registry.lookup(table_name: table_lookup.table_name)
          end
          text = text.sub(match[:table_name_container], entry)
        end
        text
      end
      DICE_REGEXP = %r{(?<dice_container>\[(?<dice>[^\]]+)\])}
      def parse_dice(text:)
        while match = text.match(DICE_REGEXP)
          evaluated_dice = Evaluators::DiceEvaluator.call(text: match[:dice], fallback: "(#{match[:dice]})")
          text = text.sub(match[:dice_container], evaluated_dice)
        end
        text
      end
    end
  end
end
