require "gm/notepad/input_handlers/default_handler"

module Gm
  module Notepad
    module InputHandlers
      class WriteToTableHandler < DefaultHandler
        HANDLED_PREFIX = "<".freeze
        def self.handles?(input:)
          return true if input.match(/^\</)
        end

        attr_accessor :index, :grep, :table_name, :line
        NON_EXPANDING_CHARATER = '!'.freeze
        WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
        WITH_WRITE_TARGET_REGEXP = %r{\A#{HANDLED_PREFIX}(?<table_name>[^:]+):(?<line>.*)}
        def after_initialize!
          self.to_filesystem = true
          self.to_interactive = true

          if match = input.match(WITH_WRITE_TARGET_REGEXP)
            input.text_to_evaluate = match[:line].strip
            table_name = match[:table_name]
            if index_match = WITH_INDEX_REGEXP.match(table_name)
              table_name = table_name.sub(index_match[:declaration], '')
              self.index = index_match[:index]
            elsif grep_match = WITH_GREP_REGEXP.match(table_name)
              table_name = table_name.sub(grep_match[:declaration], '')
              self.grep = grep_match[:grep]
            end
            self.table_name = table_name.downcase
          else
            raise "I don't know what to do"
          end
          if input.match(/^\!/)
            self.expand_line = false
            input.sub!(/^\!/, '')
          else
            self.expand_line = true
          end
          input.render_current_text(to_interactive: true  , to_output: false, to_filesystem: true)
        end

        def lines
          if index
          elsif grep
          end
          if expand_line
          else
          end
          table_registry.append(table_name: table_name, line: input.text_to_evaluate, write: true)
          []
        end
      end
    end
  end
end
