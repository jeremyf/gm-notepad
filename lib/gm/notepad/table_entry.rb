require 'gm/notepad/defaults'
module Gm
  module Notepad
    TABLE_ENTRY_RANGE_MARKER = "-".freeze
    class TableEntry
      Configuration.init!(target: self, from_config: [:column_delimiter], additional_params: [:line]) do
        row = line.split(column_delimiter)
        self.index = row.shift
        self.cells = row
      end

      include Comparable
      def <=>(other)
        to_str <=> String(other)
      end

      NUMBER_RANGE_REGEXP = %r{(?<left>\d+) *- *(?<right>\d+)}
      def lookup_range
        if match = NUMBER_RANGE_REGEXP.match(index)
          (match[:left].to_i..match[:right].to_i).map(&:to_s)
        else
          [index]
        end
      end

      attr_reader :index, :cells

      def entry
        cells.join("\t")
      end
      alias entry_column entry

      def to_s
        "[#{index}]\t#{entry}"
      end
      alias to_str entry

      private

      def index=(input)
        @index = input.strip.downcase.freeze
      end

      def cells=(input)
        @cells = Array(input).map { |i| i.strip.freeze }.freeze
      end
    end
  end
end
