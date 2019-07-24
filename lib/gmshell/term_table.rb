require_relative "exceptions"
require_relative "term_table_entry"

module Gmshell
  class TermTable
    def initialize(term:, lines:)
      self.term = term
      process(lines: lines)
    end

    def lookup(index: random_index)
      @table.fetch(index)
    end

    private

    attr_accessor :term

    def random_index
      rand(@table.size) + 1
    end

    def process(lines:)
      @table = {}
      lines.each do |line|
        entry = TermTableEntry.new(line: line)
        entry.lookup_range.each do |i|
          raise DuplicateKeyError.new(term: term, object: self) if @table.key?(i)
          @table[i] = entry
        end
      end
    end
  end
end
