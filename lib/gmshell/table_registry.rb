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

    def tables
      @registry.keys.sort
    end

    def fetch_table(name:)
      @registry.fetch(name)
    end

    def register_by_filename(term:, filename:)
      content = File.read(filename)
      register(term: term, lines: content.split("\n"))
    end

    def register_by_string(term:, string:)
      register(term: term, lines: string.split("\n"))
    end

    def lookup(term:, **kwargs)
      table = @registry.fetch(term)
      table.lookup(**kwargs)
    rescue KeyError
      "(undefined #{term})"
    end

    def evaluate(line:)
      line_evaluator.call(line: line, term_evaluation_function: method(:lookup))
    end

    private

    def register(term:, lines:)
      raise DuplicateKeyError.new(term: term, object: self) if @registry.key?(term)
      @registry[term] = Table.new(term: term, lines: lines)
    end
    attr_accessor :line_evaluator

    def default_line_evaluator
      require_relative 'line_evaluator'
      LineEvaluator.new
    end
  end
end
