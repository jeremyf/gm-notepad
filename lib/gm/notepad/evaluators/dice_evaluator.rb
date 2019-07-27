require 'dice'
module Gm
  module Notepad
    module Evaluators
      module DiceEvaluator
        def self.call(text:, fallback: text)
          if parsed_text = Dice.parse(text)
            parsed_text.evaluate.to_s
          else
            fallback.to_s
          end
        end
      end
    end
  end
end
