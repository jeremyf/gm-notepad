require 'dice'
require 'gm/notepad/parameters/table_lookup'
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
          entry = table_registry.lookup(table_name: table_lookup.table_name)
          text = text.sub(match[:table_name_container], entry)
        end
        text
      end
      DICE_REGEXP = %r{(?<dice_container>\[(?<dice>[^\]]+)\])}
      def parse_dice(text:)
        while match = text.match(DICE_REGEXP)
          if parsed_dice = Dice.parse(match[:dice])
            evaluated_dice = "#{parsed_dice.evaluate}"
          else
            evaluated_dice = "(#{match[:dice]})"
          end
          text = text.sub(match[:dice_container], evaluated_dice)
        end
        text
      end
    end
  end
end
