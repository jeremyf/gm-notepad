require 'time'
module Gmshell
  # Responsible for recording entries and then dumping them accordingly.
  class JournalEntry
    def initialize(term_registry: default_term_registry, **config)
      self.config = config
      self.timestamp = config.fetch(:timestamp) { true }
      self.io = config.fetch(:io) { default_io }
      self.logger = config.fetch(:logger) { default_logger }
      self.term_registry = term_registry
      @lines = []
    end

    HELP_REGEXP = /\A\?(?<help_with>.*)/
    def process(line:)
      line = line.to_s.strip
      if match = HELP_REGEXP.match(line)
        case match[:help_with]
        when "terms", "term"
          logger.puts("List of terms:")
          logger.puts("\t#{term_registry.terms.sort.join(", ")}")
        else
          logger.puts("Unknown help for #{match[:help_with].inspect}")
        end
      else
        record(line: line)
      end
    end

    def record(line:, as_of: Time.now)
      evaluated_line = term_registry.evaluate(line: line.to_s.strip)
      logger.puts("=>\t#{evaluated_line}")
      if timestamp?
        @lines << "#{as_of}\t#{evaluated_line}"
      else
        @lines << evaluated_line
      end
    end

    def dump!
      if !config[:skip_config_reporting]
        @io.puts "# Configuration Parameters:"
        config.each do |key, value|
          @io.puts "#   config[#{key.inspect}] = #{value.inspect}"
        end
      end
      @lines.each do |line|
        io.puts line
      end
    end

    private

    attr_accessor :io, :logger, :timestamp, :term_registry, :config

    alias timestamp? timestamp

    def default_term_registry
      require_relative "term_registry"
      TermRegistry.new
    end

    def default_io
      $stdout
    end

    def default_logger
      $stderr
    end
  end
end
