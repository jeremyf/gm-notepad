require "gm/notepad/exceptions"
require "gm/notepad/table_entry"

module Gm
  module Notepad
    class Table
      def initialize(table_name:, lines:, filename: nil, **config)
        self.config = config
        self.table_name = table_name
        self.filename = filename
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
        @table.values.uniq
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

      def append(line:, write: false)
        process(lines: [line])
        return unless filename
        return unless write
        File.open(filename, "a") do |file|
          file.puts(line)
        end
      end

      private

      attr_accessor :table_name, :filename, :config

      def random_index
        rand(@table.size)
      end

      def process(lines:)
        @table = {}
        lines.each do |line|
          entry = TableEntry.new(line: line, **config)
          entry.lookup_range.each do |i|
            key = i.to_s
            raise DuplicateKeyError.new(key: table_name, object: self) if @table.key?(key)
            @table[key] = entry
          end
        end
      end
    end
  end
end
