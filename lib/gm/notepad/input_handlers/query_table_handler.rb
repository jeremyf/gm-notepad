require 'forwardable'
require 'gm/notepad/exceptions'
require "gm/notepad/input_handlers/default_handler"
require "gm/notepad/parameters/table_lookup"
module Gm
  module Notepad
    module InputHandlers
      class QueryTableHandler < DefaultHandler
        QUERY_TABLE_NAMES_PREFIX = '+'.freeze
        def self.handles?(input:)
          # Does not have the table prefix
          return false unless input.match(/^\+/)
          # It is only the table prefix
          return false if input.match(/^\+$/)
          # It is querying all tables by way of grep
          return false if input.match(/^\+\//)
          true
        end

        def after_initialize!
          line = input[1..-1].to_s
          @table_lookup_parameters = Parameters::TableLookup.new(text: line)
          evaluate_lines!
        end

        extend Forwardable
        def_delegators :@table_lookup_parameters, :index, :grep, :table_name

        def evaluate_lines!
          begin
            table = table_registry.fetch_table(name: table_name)
          rescue MissingTableError
            message = "Unknown table #{table_name.inspect}. Did you mean: "
            message += table_registry.table_names.grep(/\A#{table_name}/).map(&:inspect).join(", ")
            input.for_rendering(text: message, to_output: false, to_interactive: true, expand_line: false)
            return
          end
          if index
            begin
              text = table.lookup(index: index)
              input.for_rendering(text: text, to_output: false, to_interactive: true, expand_line: false)
            rescue MissingTableEntryError
              input.for_rendering(text: %(Entry with index "#{index}" not found in "#{table_name}" table), to_interactive: true, to_output: false)
            end
          elsif grep
            regexp = %r{#{grep}}i
            table.grep(regexp).each do |text|
              input.for_rendering(text: text, to_output: false, to_interactive: true, expand_line: false)
            end
          else
            table.all.each do |text|
              input.for_rendering(text: text, to_output: false, to_interactive: true, expand_line: false)
            end
          end
        end
      end
    end
  end
end
