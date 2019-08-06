require 'dry-container'
module Gm
  module Notepad
    class Config
      extend Dry::Configurable

      setting :column_delimiter, "|", reader: true
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
      setting :time_to_live, 20, reader: true
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
