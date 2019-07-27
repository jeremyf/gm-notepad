module Gm
  module Notepad
    module Parameters
      # Responsible for teasing apart the table logic
      class TableLookup
        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
        WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
        WITH_EMPTY_INDEX_REGEX = %r{(?<declaration>\[\])}
        WITH_EMPTY_GREP_REGEX = %r{(?<declaration>\/\/)}

        def initialize(text:)
          @text = text
          extract_parameters!
        end

        attr_reader :index, :grep, :table_name

        def parameters
          parameters = { table_name: table_name }
          parameters[:grep] = grep if grep
          parameters[:index] = index if index
          parameters
        end

        private
        def extract_parameters!
          @parameters = {}
          text = @text
          if match = WITH_EMPTY_INDEX_REGEX.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = WITH_INDEX_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            @index = match[:index]
          elsif match = WITH_EMPTY_GREP_REGEX.match(text)
            text = text.sub(match[:declaration], '')
          elsif match = WITH_GREP_REGEXP.match(text)
            text = text.sub(match[:declaration], '')
            @grep  =  match[:grep]
          end
          @table_name = text.downcase
        end
      end
    end
  end
end
