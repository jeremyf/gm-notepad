require "gm/notepad/table"
require "gm/notepad/exceptions"

module Gm
  module Notepad
    # Responsible for loading and registering all of the named tables
    class TableRegistry
      def self.load_for(**config)
        table_registry = new(**config)
        table_registry.load!
        table_registry
      end

      def initialize(line_evaluator: default_line_evaluator, **config)
        self.config = config
        self.line_evaluator = line_evaluator
        self.paths = config.fetch(:paths) { [] }
        self.table_extension = config.fetch(:table_extension) { ".txt" }
        self.filesystem_directory = config.fetch(:filesystem_directory) { "." }
        @registry = {}
      end

      def load!
        paths.each do |path|
          Dir.glob(File.join(path, "**/*#{table_extension}")).each do |filename|
            table_name = File.basename(filename, table_extension)
            register_by_filename(table_name: table_name, filename: filename)
          end
        end
      end

      private
      attr_accessor :line_evaluator, :paths, :table_extension, :filesystem_directory, :config
      public

      def table_names
        @registry.keys.sort
      end

      def fetch_table(name:)
        @registry.fetch(name)
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
        table = @registry.fetch(table_name)
        table.lookup(**kwargs)
      rescue KeyError
        "(undefined #{table_name})"
      end

      def evaluate(line:)
        line_evaluator.call(line: line, table_lookup_function: method(:lookup))
      end

      private

      def register(table_name:, lines:, filename: nil)
        raise DuplicateKeyError.new(key: table_name, object: self) if @registry.key?(table_name)
        @registry[table_name] = Table.new(table_name: table_name, lines: lines, filename: filename, **config)
      end

      def default_line_evaluator
        require_relative 'line_evaluator'
        LineEvaluator.new
      end
    end
  end
end
