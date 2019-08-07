require 'dry-initializer'
require 'gm/notepad/container'

module Gm
  module Notepad
    TABLE_ENTRY_RANGE_MARKER = "-".freeze
    module TableEntry
      OR_LESS_REGEXP = %r{\A(?<floor>\d+) or less}i.freeze
      OR_MORE_REGEXP = %r{\A(?<ceiling>\d+) or more}i.freeze
      def self.new(line:, table:, **kwargs)
        if match = line.match(OR_LESS_REGEXP)
          OrLess.new(line: line, table: table, floor: match[:floor], **kwargs)
        elsif match = line.match(OR_MORE_REGEXP)
          OrMore.new(line: line, table: table, ceiling: match[:ceiling], **kwargs)
        else
          Base.new(line: line, table: table, **kwargs)
        end
      end
      class Base
        extend Dry::Initializer
        option :line, proc(&:to_s)
        option :table
        option :column_delimiter, default: -> { Container.resolve(:config).column_delimiter }

        def initialize(*args)
          super
          row = line.split(column_delimiter)
          self.index = row.shift
          self.cells = row
        end

        include Comparable
        def <=>(other)
          to_str <=> String(other)
        end

        def lookup(cell:)
          index = table.column_index_for(cell: cell)
          if index.nil?
            # In the file, we have cell 0 is the index. This is hidden from the cell lookup, so I
            # want to internally treat the given cell as one less.
            cells[cell.to_i - 1]
          else
            cells[index] || cells[0]
          end
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
      class OrLess < Base
        def initialize(floor:, **kwargs)
          super
          @floor = floor
          table.set_or_less_entry(self)
        end
        attr_reader :floor

        def include?(index)
          floor.to_i >= index.to_i
        end
      end
      class OrMore < Base
        def initialize(ceiling:, **kwargs)
          super
          @ceiling = ceiling
          table.set_or_more_entry(self)
        end
        attr_reader :ceiling

        def include?(index)
          ceiling.to_i <= index.to_i
        end
      end
    end
  end
end
