require "gm/notepad/exceptions"
require "gm/notepad/table_entry"

module Gm
  module Notepad
    class Table
      Configuration.init!(target: self, additional_params: [:table_name, :filename, :lines]) do
        process(lines: lines)
      end

      def lookup(index: false)
        if index
          begin
            @table.fetch(index.to_s)
          rescue KeyError
            raise MissingTableEntryError.new(table_name: table_name, index: index.to_s)
          end
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

      attr_accessor :filename, :config
      attr_reader :table_name

      def table_name=(input)
        @table_name = input.downcase
      end

      def random_index
        rand(@table.size)
      end

      def process(lines:)
        @table = {}
        lines.each do |line|
          next if line[0] == '#'
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
