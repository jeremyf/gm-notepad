require 'gm/notepad/defaults'
module Gm
  module Notepad
    # Global configuration values
    class Configuration
      CLI_CONFIG_DEFAULTS = {
        report_config: false,
        defer_output: false,
        filesystem_directory: '.',
        interactive_buffer: $stderr,
        interactive_color: true,
        output_color: false,
        list_tables: false,
        output_buffer: $stdout,
        paths: ['.'],
        column_delimiter: Gm::Notepad::DEFAULT_COLUMN_DELIMITER,
        shell_prompt: Gm::Notepad::DEFAULT_SHELL_PROMPT,
        skip_readlines: false,
        table_extension: '.txt',
        with_timestamp: false
      }.freeze

      INTERNAL_CONFIG_DEFAULTS_METHOD_NAMES = [
        :input_processor,
        :renderer,
        :table_registry
      ]

      def self.init!(klass, with:, &block)
        klass.define_method(:initialize) do |config:|
          @config = config
          instance_exec(&block) if block
        end
        with.each do |method_name|
          klass.define_method(method_name) do
            config.public_send(method_name)
          end
        end
        klass.attr_reader :config
      end

      def initialize(table_registry: nil, renderer: nil, input_processor: nil, **overrides)
        CLI_CONFIG_DEFAULTS.each_pair do |key, default_value|
          value = overrides.fetch(key, default_value)
          if !value.is_a?(IO)
            value = value.clone
            value.freeze
          end
          self.send("#{key}=", value)
        end
        self.table_registry = (table_registry || default_table_registry)
        self.renderer = (renderer || default_renderer)
        self.input_processor = (input_processor || default_input_processor)
      end
      attr_reader(*CLI_CONFIG_DEFAULTS.keys)
      attr_reader(*INTERNAL_CONFIG_DEFAULTS_METHOD_NAMES)

      def to_hash
        config = CLI_CONFIG_DEFAULTS.keys.each_with_object({}) do |key, mem|
          mem[key] = send(key)
        end
        INTERNAL_CONFIG_DEFAULTS_METHOD_NAMES.each_with_object(config) do |key, mem|
          mem[key] = send(key)
        end
      end

      private
      attr_writer(*CLI_CONFIG_DEFAULTS.keys)
      attr_writer(*INTERNAL_CONFIG_DEFAULTS_METHOD_NAMES)

      def default_input_processor
        require "gm/notepad/input_processor"
        InputProcessor.new(**self)
      end

      def default_table_registry
        require "gm/notepad/table_registry"
        TableRegistry.load_for(**self)
      end

      def default_renderer
        require 'gm/notepad/line_renderer'
        LineRenderer.new(**self)
      end
    end
  end
end
