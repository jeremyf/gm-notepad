require "gm/notepad/input_handlers/default_handler"

module Gm
  module Notepad
    module InputHandlers
      class WriteToTableHandler < DefaultHandler
        HANDLED_PREFIX = "<".freeze
        def self.handles?(input:)
          return true if input[0] == HANDLED_PREFIX
        end

        attr_accessor :index, :grep, :table_name, :line
        NON_EXPANDING_CHARATER = '!'.freeze
        WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
        WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
        WITH_WRITE_TARGET_REGEXP = %r{\A#{HANDLED_PREFIX}(?<table_name>[^:]+):(?<line>.*)}
        def after_initialize!
          self.to_filesystem = true
          self.to_interactive = true

          if match = WITH_WRITE_TARGET_REGEXP.match(input)
            line = match[:line].strip
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
          if line[0] == NON_EXPANDING_CHARATER
            self.expand_line = false
            self.line = line[1..-1]
          else
            self.expand_line = true
          end
          self.line = line.strip
        end

        def lines
          if index
          elsif grep
          end
          if expand_line
          else
          end
          table_registry.append(table_name: table_name, line: line, write: true)
          []
        end
      end
    end
  end
end
