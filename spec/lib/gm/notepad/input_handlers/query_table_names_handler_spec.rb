require 'spec_helper'
require 'gm/notepad/table_registry'
require 'gm/notepad/input_handlers/query_table_names_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe QueryTableNamesHandler do
        let(:registry) { TableRegistry.new(config: Configuration.defaults_for(:paths, :table_extension, :filesystem_directory)) }
        let(:handler) { described_class.new(input: input, table_registry: registry) }
        let(:input) { "" }
        subject { handler }
        its(:to_interactive) { is_expected.to be_truthy }
        its(:to_output) { is_expected.to be_falsey }
        its(:to_filesystem) { is_expected.to be_falsey }
        its(:expand_line?) { is_expected.to be_falsey }

        describe ".handles?" do
          subject { described_class }
          it { is_expected.to handle("+/") }
          it { is_expected.not_to handle("?") }
          it { is_expected.to handle("+") }
          it { is_expected.not_to handle("+some") }
        end

        describe '#lines' do
          [
            [['abc', 'daz', 'bcd', 'def', 'xyz'], 'a\w', ['abc', 'daz']],
            [['abc', 'daz', 'bcd', 'def', 'xyz'], nil, ['abc', 'daz', 'bcd', 'def', 'xyz'].sort],
            [['abc', 'daz', 'bcd', 'def', 'xyz'], '^a', ['abc']]
          ].each_with_index do |(table_names, grep, expected), index|
            context "for table_names: #{table_names.sort.inspect}, grep: #{grep.inspect} (index: #{index})" do
              before do
                table_names.each do |table_name|
                  registry.register_by_string(table_name: table_name, string: "")
                end
              end
              let(:input) { "+/#{grep}/"}
              subject { handler.lines }
              it { is_expected.to eq(expected) }
            end
          end
        end
      end
    end
  end
end
