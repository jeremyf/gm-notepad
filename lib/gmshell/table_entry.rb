module Gmshell
  TABLE_ENTRY_SEPARATOR = "|".freeze
  TABLE_ENTRY_RANGE_MARKER = "-".freeze
  class TableEntry
    def initialize(line:)
      self.lookup_column, self.entry_column = line.split(TABLE_ENTRY_SEPARATOR)
    end

    include Comparable
    def <=>(other)
      lookup_column <=> other.lookup_column
    end

    def lookup_range
      left, right = lookup_column.split(TABLE_ENTRY_RANGE_MARKER)
      right = left unless right
      (left.strip.to_i..right.strip.to_i)
    end

    attr_reader :lookup_column, :entry_column

    alias to_s entry_column
    alias to_str entry_column

    private

    def lookup_column=(input)
      @lookup_column = input.strip.freeze
    end

    def entry_column=(input)
      @entry_column = input.strip.freeze
    end
  end
end
