module Gmshell
  TERM_TABLE_ENTRY_SEPARATOR = "|".freeze
  TERM_TABLE_ENTRY_RANGE_MARKER = "-".freeze
  class TermTableEntry
    def initialize(line:)
      self.lookup_column, self.entry_column = line.split(TERM_TABLE_ENTRY_SEPARATOR)
    end

    def lookup_range
      left, right = lookup_column.split(TERM_TABLE_ENTRY_RANGE_MARKER)
      right = left unless right
      (left.strip.to_i..right.strip.to_i)
    end

    attr_reader :lookup_column, :entry_column
    alias to_s entry_column
    alias to_str entry_column

    private

    def lookup_column=(input)
      @lookup_column = input.strip
    end

    def entry_column=(input)
      @entry_column = input.strip
    end
  end
end
