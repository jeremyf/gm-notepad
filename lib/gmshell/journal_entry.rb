require 'time'
module Gmshell
  class JournalEntry
    def initialize(config)
      self.config = config
      self.term_registry = config.fetch(:term_registry) { default_term_registry }
      self.term_expander = config.fetch(:term_expander) { default_term_expander }
      @lines = []
    end

    def add(line:)
      line = term_expander.expand(line: line, term_registry: term_registry)
      $stdout.puts("=>\t#{line}")
      if timestamp?
        @lines << "#{Time.now}\t#{line}"
      else
        @lines << line
      end
    end

    def dump!
      @lines.each do |line|
        io.puts line
      end
    end

    private

    attr_accessor :term_expander, :config, :term_registry

    def io
      config.fetch(:io)
    end

    def timestamp?
      config[:timestamp]
    end

    def default_term_expander
      TermExpander.new
    end

    def default_term_registry
      TermRegistry.new
    end
  end

  class TermExpander
    TOKEN_REGEXP = %r{(?<term_container>\{(?<term>[^\}]+)\})}
    def expand(line:, term_registry:)
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
