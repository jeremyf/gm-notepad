require 'dice'
module Gmshell
  # Responsible for recording entries and then dumping them accordingly.
  class LineEvaluator
    TERM_REGEXP = %r{(?<term_container>\{(?<term>[^\}]+)\})}
    DICE_REGEXP = %r{(?<dice_container>\[(?<dice>[^\]]+)\])}
    def call(line:, term_evaluation_function:, expand: true)
      return line unless expand
      while match = line.match(TERM_REGEXP)
        evaluated_term = term_evaluation_function.call(term: match[:term].strip)
        line = line.sub(match[:term_container], evaluated_term)
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
