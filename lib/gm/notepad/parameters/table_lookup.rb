require 'gm/notepad/evaluators/dice_evaluator'
module Gm
  module Notepad
    module Parameters
      # Responsible for teasing apart the table logic
      class TableLookup
        def initialize(text:, roll_dice: false)
          @text = text.strip
          @role_dice = false
          @parameters = {}
          extract_parameters!
          roll_them_bones! if roll_dice
        end

        attr_reader :cell, :index, :grep, :table_name

        def parameters
          parameters = { table_name: table_name }
          parameters[:grep] = grep if grep
          parameters[:index] = index if index
          parameters[:cell] = cell if cell
          parameters
        end

        private

        attr_writer :cell, :index, :grep, :table_name

        def roll_them_bones!
          if index
            self.index = Evaluators::DiceEvaluator.call(text: index)
          end
          if cell
            self.cell = Evaluators::DiceEvaluator.call(text: cell)
          end
        end

        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<found>[^\/]+)/)}
        WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<found>[^\]]+)\])}
        CELL_WITHOUT_INDEX_REGEXP = %r{(?<declaration>\[\]\[(?<found>[^\]]+)\])}
        EMPTY_INDEX_EMPTY_CELL_REGEXP = %r{(?<declaration>\[\]\[\])}
        WITH_EMPTY_INDEX_REGEX = %r{(?<declaration>\[\])}
        WITH_EMPTY_GREP_REGEX = %r{(?<declaration>\/\/)}

        def extract_parameters!
          text = @text
          if match = EMPTY_INDEX_EMPTY_CELL_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = CELL_WITHOUT_INDEX_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            self.cell = match[:found]
          elsif match = WITH_EMPTY_INDEX_REGEX.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = WITH_INDEX_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            self.index = match[:found]
            # Moving on to the cell
            if match = WITH_EMPTY_INDEX_REGEX.match(text)
              text = text.sub(match[:declaration], '')
            elsif match = WITH_INDEX_REGEXP.match(text)
              text = text.sub(match[:declaration], '')
              self.cell = match[:found]
            end
          elsif match = WITH_EMPTY_GREP_REGEX.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = WITH_GREP_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            self.grep  =  match[:found]
          end
          self.table_name = text.downcase
        end
      end
    end
  end
end
