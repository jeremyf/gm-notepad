require 'gm/notepad/defaults'
module Gm
  module Notepad
    TABLE_ENTRY_RANGE_MARKER = "-".freeze
    class TableEntry
      Configuration.init!(target: self, from_config: [:column_delimiter], additional_params: [:line]) do
        self.index, self.entry_column = line.split(column_delimiter)
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

      attr_reader :index, :entry_column

      def to_s
        "[#{index}]\t#{entry_column}"
      end
      alias to_str entry_column

      private

      def index=(input)
        @index = input.strip.downcase.freeze
      end

      def entry_column=(input)
        @entry_column = input.strip.freeze
      end
    end
  end
end
