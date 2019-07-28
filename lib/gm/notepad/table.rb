require "gm/notepad/exceptions"
require "gm/notepad/configuration"
require "gm/notepad/table_entry"
require "gm/notepad/table_column_set"

module Gm
  module Notepad
    class Table
      Configuration.init!(target: self, from_config: [:column_delimiter, :index_entry_prefix], additional_params: [:table_name, :filename, :lines]) do
        @index_entry_prefix_regexp = %r{^#{Regexp.escape(index_entry_prefix)} *#{Regexp.escape(column_delimiter)}}i.freeze
        set_null_table_column_set!
        process(lines: lines)
      end

      def lookup(index: false, cell: false)
        if index && cell
          lookup_entry_by(index: index).lookup(cell: cell)
        elsif index
          lookup_entry_by(index: index)
        elsif cell
          lookup_random_entry.lookup(cell: cell)
        else
          lookup_random_entry
        end
      end

      def all
        @table.values.uniq
      end

      def column_names
        @table_column_set.names
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

      def lookup_entry_by(index:)
        begin
          @table.fetch(index.to_s)
        rescue KeyError
          raise MissingTableEntryError.new(table_name: table_name, index: index.to_s)
        end
      end

      def lookup_random_entry
        @table.values[random_index]
      end

      attr_accessor :filename, :config
      attr_reader :table_name

      def table_name=(input)
        @table_name = input.downcase
      end

      def random_index
        rand(@table.size)
      end

      STARTS_WITH_COMMENT_REGEXP = %r{\A#}
      def process(lines:)
        @table = {}
        lines.each do |line|
          line = line.strip
          # Handle Comment
          case line
          when STARTS_WITH_COMMENT_REGEXP
            next
          when @index_entry_prefix_regexp
            register_index_declaration!(line: line)
          else
            make_entry!(line: line)
          end
        end
      end

      def set_null_table_column_set!
        @table_column_set = TableColumnSet::Null.new
      end

      def register_index_declaration!(line:)
        @table_column_set = TableColumnSet.new(table: self, line: line, config: config)
      end

      def make_entry!(line:)
        entry = TableEntry.new(table: self, line: line, config: config)
        entry.lookup_range.each do |i|
          key = i.to_s
          raise DuplicateKeyError.new(key: table_name, object: self) if @table.key?(key)
          @table[key] = entry
        end
      end
    end
  end
end
