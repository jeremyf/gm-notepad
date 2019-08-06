require 'dry-container'

module Gm
  module Notepad
    # A container for dependency injection
    class Container
      extend Dry::Container::Mixin

      register "config" do
        require 'gm/notepad/config'
        Config
      end

      register "table_registry" do
        require 'gm/notepad/table_registry'
        TableRegistry.build_and_load
      end

      register "input_handler_registry" do
        # Order matters. The first registered will be the first to
        # answer "Can you handle the input?"
        require "gm/notepad/input_handler_registry"
        require "gm/notepad/input_handlers/help_handler"
        require "gm/notepad/input_handlers/comment_handler"
        require "gm/notepad/input_handlers/query_table_handler"
        require "gm/notepad/input_handlers/query_table_names_handler"
        require "gm/notepad/input_handlers/write_to_table_handler"
        require "gm/notepad/input_handlers/write_line_handler"
        require "gm/notepad/input_handlers/shell_out_handler"
        InputHandlerRegistry.new do |registry|
          registry.register(handler: InputHandlers::HelpHandler)
          registry.register(handler: InputHandlers::CommentHandler)
          registry.register(handler: InputHandlers::ShellOutHandler)
          registry.register(handler: InputHandlers::QueryTableHandler)
          registry.register(handler: InputHandlers::QueryTableNamesHandler)
          registry.register(handler: InputHandlers::WriteToTableHandler)
          registry.register(handler: InputHandlers::WriteLineHandler)
        end
      end
    end
  end
end
