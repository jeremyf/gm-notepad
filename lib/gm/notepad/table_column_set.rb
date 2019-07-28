require "gm/notepad/exceptions"
require "gm/notepad/configuration"

module Gm
  module Notepad
    class TableColumnSet
      # Because we may not have an index row, from which we create a TableColumnSet.
      # So this class provides the necessary external interface.
      class Null
        def names
          []
        end
      end

      Configuration.init!(target: self, additional_params: [:table, :line], from_config: [:column_delimiter]) do
        @columns = []
        @index =
        process_line!
      end

      def names
        @columns.map(&:to_s)
      end

      private
      def process_line!
        columns = line.split(column_delimiter)
        @index = columns.shift
        @columns = columns.map {|c| c.strip.downcase }
      end
    end
  end
end
