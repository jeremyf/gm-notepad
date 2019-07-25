require 'dice'
module Gmshell
  # Responsible for recording entries and then dumping them accordingly.
  class LineEvaluator
    TABLE_NAME_REGEXP = %r{(?<table_name_container>\{(?<table_name>[^\}]+)\})}
    DICE_REGEXP = %r{(?<dice_container>\[(?<dice>[^\]]+)\])}
    def call(line:, table_lookup_function:, expand: true)
      return line unless expand
      while match = line.match(TABLE_NAME_REGEXP)
        evaluated_table_name = table_lookup_function.call(table_name: match[:table_name].strip)
        line = line.sub(match[:table_name_container], evaluated_table_name)
      end
      while match = line.match(DICE_REGEXP)
        if parsed_dice = Dice.parse(match[:dice])
          evaluated_dice = "#{parsed_dice.evaluate} (#{match[:dice]})"
        else
          evaluated_dice = "(#{match[:dice]})"
        end
        line = line.sub(match[:dice_container], evaluated_dice)
      end
      line
    end
  end
end
