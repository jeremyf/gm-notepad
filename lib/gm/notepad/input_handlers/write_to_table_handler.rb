require "gm/notepad/input_handlers/default_handler"

module Gm
  module Notepad
    module InputHandlers
      class WriteToTableHandler < DefaultHandler
        HANDLED_PREFIX = "<".freeze
        def self.handles?(input:)
          return true if input.match(/^\</)
        end

        NON_EXPANDING_CHARATER = '!'.freeze
        WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
        WITH_WRITE_TARGET_REGEXP = %r{\A#{HANDLED_PREFIX}(?<table_name>[^:]+):(?<line>.*)}
        def after_initialize!
          if match = input.match(WITH_WRITE_TARGET_REGEXP)
            input.text_to_evaluate = match[:line].strip
            table_name = match[:table_name]
            if index_match = WITH_INDEX_REGEXP.match(table_name)
              table_name = table_name.sub(index_match[:declaration], '')
              index = index_match[:index]
            elsif grep_match = WITH_GREP_REGEXP.match(table_name)
              table_name = table_name.sub(grep_match[:declaration], '')
              grep = grep_match[:grep]
            end
            table_name = table_name.downcase
          else
            raise "I don't know what to do"
          end
          if input.match(/^\!/)
            expand_line = false
            input.sub!(/^\!/, '')
          else
            expand_line = true
          end
          input.for_rendering(table_name: table_name, text: input.text_to_evaluate, to_interactive: true  , to_output: false, to_filesystem: true, expand_line: expand_line)
        end
      end
    end
  end
end
