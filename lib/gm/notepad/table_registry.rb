require 'dry-initializer'
require "gm/notepad/table"
require "gm/notepad/exceptions"
require 'gm/notepad/line_evaluator'
require 'gm/notepad/container'

module Gm
  module Notepad
    # Responsible for loading and registering all of the named tables
    class TableRegistry
      def self.build_and_load
        new { load! }
      end

      extend Dry::Initializer
      option :paths, default: -> { Container.resolve(:config).paths }
      option :table_extension, default: -> { Container.resolve(:config).table_extension }
      option :filesystem_directory, default: -> { Container.resolve(:config).filesystem_directory }
      option :registry, default: -> { Hash.new }
      option :line_evaluator, default: -> { LineEvaluator.new(table_registry: self) }

      def initialize(*args, &block)
        super
        instance_exec(&block) if block_given?
      end

      attr_reader :line_evaluator, :registry

      def table_names
        registry.keys.sort
      end

      def fetch_table(name:)
        registry.fetch(name.downcase)
      rescue KeyError
        raise MissingTableError.new(name: name.downcase)
      end

      def append(table_name:, line:, write:)
        table = nil
        begin
          table = fetch_table(name: table_name)
        rescue MissingTableError
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
      rescue MissingTableError, MissingTableEntryError => e
        e.to_buffer_message
      end

      def evaluate(line:)
        line_evaluator.call(line: line)
      end

      private

      def load!
        paths.each do |path|
          Dir.glob(File.join(path, "**/*#{table_extension}")).each do |filename|
            table_name = File.basename(filename, table_extension)
            register_by_filename(table_name: table_name, filename: filename)
          end
        end
      end

      def register(table_name:, lines:, filename: nil)
        table_name = table_name.downcase
        raise DuplicateKeyError.new(key: table_name, object: self) if registry.key?(table_name.downcase)
        registry[table_name] = Table.new(table_name: table_name, lines: lines, filename: filename)
      end
    end
  end
end
