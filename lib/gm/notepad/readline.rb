require 'readline'
module Gm
  module Notepad
    # A configuration module for the Readline module
    module Readline

      QUERY_TABLE_NAMES_PREFIX = /^\+(?<table_name>.*)/.freeze
      TABLE_EXPANSION_REGEXP = %r{(?<table_container>\{(?<table_name>.*))}.freeze
      def self.completion_function(string, table_registry: Container.resolve(:table_registry))
        entries = []
        if match = string.match(QUERY_TABLE_NAMES_PREFIX)
          entries += table_registry.table_names.grep(/^#{Regexp.escape(match[:table_name])}/).map { |name| "+#{name}" }
        end
        if match = string.match(TABLE_EXPANSION_REGEXP)
          test_string = string.sub(match[:table_container], "{")
          entries += table_registry.table_names.grep(/^#{Regexp.escape(match[:table_name])}/).map { |name| "#{test_string}#{name}}"}
        end
        entries += history_for(string)
        entries.uniq.sort
      end

      def self.history_for(string)
        ::Readline::HISTORY.grep(/^#{Regexp.escape(string)}/)
      end

      # Check history for existing matches
      completion_function = method(:completion_function)

      if ::Readline.respond_to?("basic_word_break_characters=")
        ::Readline.basic_word_break_characters= " \t\n`><=;|&{("
      end

      # With a sucessful completion add this to the end
      ::Readline.completion_append_character = " "

      # Without this, when I had in history the following: ["{name}"]
      # And would type `{\t` into the shell, I would get the following
      # result: "{{name}".
      ::Readline.completer_word_break_characters = ""

      # Hook-in the above completion function
      ::Readline.completion_proc = completion_function

      # In the interactive shell, where are we sending the prompts?
      # If this defaults to $stdout then if we are directing $stdout
      # to a file, we end up typing blind into the terminal
      ::Readline.output = $stderr

      def self.input_getter(**config)
        -> { ::Readline.readline("", true) }
      end
    end
  end
end
