require 'forwardable'
require "gm/notepad/input_handlers/default_handler"
require "gm/notepad/parameters/table_lookup"
module Gm
  module Notepad
    module InputHandlers
      class QueryTableHandler < DefaultHandler
        QUERY_TABLE_NAMES_PREFIX = '+'.freeze
        def self.handles?(input:)
          # Does not have the table prefix
          return false unless input[0] == QUERY_TABLE_NAMES_PREFIX
          # It is only the table prefix
          return false if input == QUERY_TABLE_NAMES_PREFIX
          # It is querying all tables by way of grep
          return false if input[0..1] == "#{QUERY_TABLE_NAMES_PREFIX}/"
          true
        end

        def after_initialize!
          self.expand_line = false
          self.to_output = false
          self.to_interactive = true

          line = input[1..-1].to_s
          self.expand_line = false
          @table_lookup_parameters = Parameters::TableLookup.new(text: line)
        end

        extend Forwardable
        def_delegators :@table_lookup_parameters, :index, :grep, :table_name

        def lines
          begin
            table = table_registry.fetch_table(name: table_name)
          rescue KeyError
            message = "Unknown table #{table_name.inspect}. Did you mean: "
            message += table_registry.table_names.grep(/\A#{table_name}/).map(&:inspect).join(", ")
            return [message]
          end
          if index
            begin
              [table.lookup(index: index)]
            rescue KeyError
              [%(Entry with index "#{index}" not found in "#{table_name}" table)]
            end
          elsif grep
            regexp = %r{#{grep}}i
            table.grep(regexp)
          else
            table.all
          end
        end
      end
    end
  end
end
