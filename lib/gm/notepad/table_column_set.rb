require 'dry-initializer'
require 'gm/notepad/container'

module Gm
  module Notepad
    class TableColumnSet
      # Because we may not have an index row, from which we create a TableColumnSet.
      # So this class provides the necessary external interface.
      class Null
        def names
          []
        end

        def column_index_for(cell:)
          cell.to_i
        end
      end

      extend Dry::Initializer
      option :line, proc(&:to_s)
      option :table
      option :column_delimiter, default: -> { Container.resolve(:config).column_delimiter }

      def initialize(*args)
        super
        process_line!
      end

      def names
        @column_registry.map(&:to_s)
      end

      def column_index_for(cell:)
        @column_registry.index(cell.downcase)
      end


      private
      def process_line!
        columns = line.split(column_delimiter)
        @index = columns.shift
        @column_registry = columns.map {|c| c.strip.downcase }
      end
    end
  end
end
