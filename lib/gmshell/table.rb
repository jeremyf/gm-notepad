require_relative "exceptions"
require_relative "table_entry"

module Gmshell
  class Table
    def initialize(table_name:, lines:)
      self.table_name = table_name
      process(lines: lines)
    end

    def lookup(index: false)
      if index
        @table.fetch(index)
      else
        @table.values[random_index]
      end
    end

    def all
      @table.values
    end

    def grep(expression)
      returning_value = []
      @table.each_value do |entry|
        if expression.match(entry.entry_column)
          returning_value << entry
        end
      end
      returning_value
    end

    private

    attr_accessor :table_name

    def random_index
      rand(@table.size)
    end

    def process(lines:)
      @table = {}
      lines.each do |line|
        entry = TableEntry.new(line: line)
        entry.lookup_range.each do |i|
          key = i.to_s
          raise DuplicateKeyError.new(key: table_name, object: self) if @table.key?(key)
          @table[key] = entry
        end
      end
    end
  end
end
