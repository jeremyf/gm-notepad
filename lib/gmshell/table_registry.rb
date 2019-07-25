require_relative "table"
require_relative "exceptions"

module Gmshell
  class TableRegistry
    def self.load_for(paths:)
      table_registry = new
      paths.each do |path|
        Dir.glob(File.join(path, "**/*.txt")).each do |filename|
          term = File.basename(filename, ".txt")
          table_registry.register_by_filename(term: term, filename: filename)
        end
      end
      table_registry
    end

    def initialize(line_evaluator: default_line_evaluator)
      self.line_evaluator = line_evaluator
      @registry = {}
    end

    def table_names
      @registry.keys.sort
    end

    def fetch_table(name:)
      @registry.fetch(name)
    end

    def register_by_filename(term:, table_name: term, filename:)
      content = File.read(filename)
      register(term: table_name, lines: content.split("\n"))
    end

    def register_by_string(term:, table_name: term, string:)
      register(term: table_name, lines: string.split("\n"))
    end

    def lookup(term:, table_name: term, **kwargs)
      table = @registry.fetch(table_name)
      table.lookup(**kwargs)
    rescue KeyError
      "(undefined #{table_name})"
    end

    def evaluate(line:)
      line_evaluator.call(line: line, term_evaluation_function: method(:lookup))
    end

    private

    def register(term:, table_name: term, lines:)
      raise DuplicateKeyError.new(term: table_name, object: self) if @registry.key?(table_name)
      @registry[table_name] = Table.new(term: table_name, lines: lines)
    end
    attr_accessor :line_evaluator

    def default_line_evaluator
      require_relative 'line_evaluator'
      LineEvaluator.new
    end
  end
end
