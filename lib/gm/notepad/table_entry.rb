require 'gm/notepad/defaults'
module Gm
  module Notepad
    TABLE_ENTRY_RANGE_MARKER = "-".freeze
    class TableEntry
      Configuration.init!(target: self, from_config: [:column_delimiter], additional_params: [:line]) do
        self.lookup_column, self.entry_column = line.split(column_delimiter)
      end

      include Comparable
      def <=>(other)
        to_str <=> String(other)
      end

      NUMBER_RANGE_REGEXP = %r{(?<left>\d+) *- *(?<right>\d+)}
      def lookup_range
        if match = NUMBER_RANGE_REGEXP.match(lookup_column)
          (match[:left].to_i..match[:right].to_i).map(&:to_s)
        else
          [lookup_column]
        end
      end

      attr_reader :lookup_column, :entry_column

      def to_s
        "[#{lookup_column}]\t#{entry_column}"
      end
      alias to_str entry_column

      private

      def lookup_column=(input)
        @lookup_column = input.strip.downcase.freeze
      end

      def entry_column=(input)
        @entry_column = input.strip.freeze
      end
    end
  end
end
