require_relative "term_table"
require_relative "exceptions"

module Gmshell
  class TermRegistry
    def self.load_for(paths:)
      term_registry = new
      paths.each do |path|
        Dir.glob(File.join(path, "**/*.txt")).each do |filename|
          term = File.basename(filename, ".txt")
          term_registry.register_by_filename(term: term, filename: filename)
        end
      end
      term_registry
    end

    def initialize(line_evaluator: default_line_evaluator)
      self.line_evaluator = line_evaluator
      @registry = {}
    end

    def terms
      @registry.keys
    end

    def register_by_filename(term:, filename:)
      content = File.read(filename)
      register(term: term, lines: content.split("\n"))
    end

    def register_by_string(term:, string:)
      register(term: term, lines: string.split("\n"))
    end

    def lookup(term:, **kwargs)
      term_table = @registry.fetch(term)
      term_table.lookup(**kwargs)
    end

    def evaluate(line:)
      line_evaluator.call(line: line, term_evaluation_function: method(:lookup))
    end

    private

    def register(term:, lines:)
      raise DuplicateKeyError.new(term: term, object: self) if @registry.key?(term)
      @registry[term] = TermTable.new(term: term, lines: lines)
    end
    attr_accessor :line_evaluator

    def default_line_evaluator
      require_relative 'line_evaluator'
      LineEvaluator.new
    end
  end
end
