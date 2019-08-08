require 'dry-container'
require 'shellwords'
module Gm
  module Notepad
    class Config
      # A quick and dirty file parser for configuration options
      def self.merge_with_config_file(config:)
        return config unless config.key?(:config_file)
        config_file = {}
        config_file_content = File.read(config[:config_file])
        config_file_content.split("\n").each do |config_line|
          keyword, value = config_line.split("=")
          keyword = keyword.sub(/^-+/, '')
          if value.nil?
            # Grab the negating value, because we have a boolean parameter
            # (e.g. no associated value)
            value = !self.public_send(keyword)
          else
            value = Shellwords.shellwords(value).join(" ")
          end
          if keyword == 'paths'
            config_file[keyword.to_sym] ||= []
            config_file[keyword.to_sym] << value
          else
            config_file[keyword.to_sym] = value
          end
        end
        config_file.merge(config)
      end

      extend Dry::Configurable

      COLUMN_DELMITER_MAP = {
        "t" => "\t",
        '\t' => "\t",
      }.freeze

      setting(:column_delimiter, "|", reader: true) { |value| COLUMN_DELMITER_MAP.fetch(value, value) }
      setting :config_file, nil, reader: true
      setting :filesystem_directory, '.', reader: true
      setting :include_original_command_as_comment, true, reader: true
      setting :index_entry_prefix, "index", reader: true
      setting :interactive_buffer, $stderr, reader: true
      setting :interactive_color, :faint, reader: true
      setting :list_tables, false, reader: true
      setting :output_buffer, $stdout, reader: true
      setting :output_color, false, reader: true
      setting :paths, ['.'], reader: true
      setting :report_config, false, reader: true
      setting :skip_readlines, false, reader: true
      setting :table_extension, '.txt', reader: true
      setting :time_to_live, 100, reader: true
      setting :with_timestamp, false, reader: true

      def self.index_entry_prefix_regexp
        %r{^#{Regexp.escape(index_entry_prefix)} *#{Regexp.escape(column_delimiter)}}i
      end

      def index_entry_prefix_regexp
        %r{^#{Regexp.escape(index_entry_prefix)} *#{Regexp.escape(column_delimiter)}}i
      end
    end
  end
end
