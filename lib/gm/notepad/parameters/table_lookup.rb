module Gm
  module Notepad
    module Parameters
      # Responsible for teasing apart the table logic
      class TableLookup
        def initialize(text:)
          @text = text
          extract_parameters!
        end

        attr_accessor :cell, :index, :grep, :table_name

        def parameters
          parameters = { table_name: table_name }
          parameters[:grep] = grep if grep
          parameters[:index] = index if index
          parameters[:cell] = cell if cell
          parameters
        end

        private
        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<found>[^\/]+)/)}
        WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<found>[^\]]+)\])}
        WITH_EMPTY_INDEX_REGEX = %r{(?<declaration>\[\])}
        WITH_EMPTY_GREP_REGEX = %r{(?<declaration>\/\/)}

        def extract_parameters!
          @parameters = {}
          text = @text
          if match = WITH_EMPTY_INDEX_REGEX.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = WITH_INDEX_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            @index = match[:found]
            # Moving on to the cell
            if match = WITH_EMPTY_INDEX_REGEX.match(text)
              text = text.sub(match[:declaration], '')
            elsif match = WITH_INDEX_REGEXP.match(text)
              text = text.sub(match[:declaration], '')
              @cell = match[:found]
            end
          elsif match = WITH_EMPTY_GREP_REGEX.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = WITH_GREP_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            @grep  =  match[:found]
          end
          @table_name = text.downcase
        end
      end
    end
  end
end
