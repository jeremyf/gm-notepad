require 'time'
module Gmshell
  class JournalEntry
    def initialize(**config)
      self.config = config
      self.io = config.fetch(:io) { $stdout }
      self.logger = config.fetch(:logger) { $stderr }
      self.term_registry = config.fetch(:term_registry) { default_term_registry }
      self.line_evaluator = config.fetch(:line_evaluator) { default_line_evaluator }
      @lines = []
    end

    def write(line:)
      evaluated_line = line_evaluator.call(line: line.to_s.strip, term_registry: term_registry)
      logger.puts("=>\t#{evaluated_line}")
      if timestamp?
        @lines << "#{Time.now}\t#{evaluated_line}"
      else
        @lines << evaluated_line
      end
    end

    def dump!
      @lines.each do |line|
        io.puts line
      end
    end

    private

    attr_accessor :line_evaluator, :config, :term_registry, :io, :logger

    def timestamp?
      config[:timestamp]
    end

    def default_line_evaluator
      LineEvaluator
    end

    def default_term_registry
      TermRegistry.new
    end
  end

  module LineEvaluator
    TOKEN_REGEXP = %r{(?<term_container>\{(?<term>[^\}]+)\})}
    def self.call(line:, term_registry:)
      while match = line.match(TOKEN_REGEXP)
        evaluated_term = term_registry.evaluate(term: match[:term])
        line.sub!(match[:term_container], evaluated_term)
      end
      line
    end
  end

  class TermRegistry
    def evaluate(term:)
      "'unknown #{term}'"
    end
  end
end
