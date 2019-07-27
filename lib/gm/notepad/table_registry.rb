require "gm/notepad/table"
require "gm/notepad/exceptions"
require 'gm/notepad/line_evaluator'

module Gm
  module Notepad
    # Responsible for loading and registering all of the named tables
    class TableRegistry
      def self.load_for(config:)
        table_registry = new(config: config)
        table_registry.load!
        table_registry
      end

      Configuration.init!(self, with: [:paths, :table_extension, :filesystem_directory]) do
        @registry = {}
        @line_evaluator = LineEvaluator.new
      end

      def load!
        paths.each do |path|
          Dir.glob(File.join(path, "**/*#{table_extension}")).each do |filename|
            table_name = File.basename(filename, table_extension)
            register_by_filename(table_name: table_name, filename: filename)
          end
        end
      end

      attr_reader :line_evaluator, :registry

      def table_names
        registry.keys.sort
      end

      def fetch_table(name:)
        registry.fetch(name.downcase)
      end

      def append(table_name:, line:, write:)
        table = nil
        begin
          table = fetch_table(name: table_name)
        rescue KeyError
          filename = File.join(filesystem_directory, "#{table_name}#{table_extension}")
          table = register(table_name: table_name, lines: [], filename: filename)
        end
        table.append(line: line, write: write)
      end

      def register_by_filename(table_name:, filename:)
        content = File.read(filename)
        register(table_name: table_name, lines: content.split("\n"), filename: filename)
      end

      def register_by_string(table_name:, string:)
        register(table_name: table_name, lines: string.split("\n"))
      end

      def lookup(table_name:, **kwargs)
        table = fetch_table(name: table_name)
        table.lookup(**kwargs)
      rescue KeyError
        "(undefined #{table_name})"
      end

      def evaluate(line:)
        line_evaluator.call(line: line, table_lookup_function: method(:lookup))
      end

      private

      def register(table_name:, lines:, filename: nil)
        table_name = table_name.downcase
        raise DuplicateKeyError.new(key: table_name, object: self) if registry.key?(table_name.downcase)
        registry[table_name] = Table.new(table_name: table_name, lines: lines, filename: filename, **config)
      end
    end
  end
end
