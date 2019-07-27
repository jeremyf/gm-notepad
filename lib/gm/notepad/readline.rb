require 'readline'
module Gm
  module Notepad
    # A configuration module for the Readline module
    module Readline

      # Check history for existing matches
      completion_function = proc do |string|
        ::Readline::HISTORY.grep(/^#{Regexp.escape(string)}/)
      end
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
