require 'spec_helper'
require 'gm/notepad/table_registry'
require 'gm/notepad/input_handlers/query_table_names_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe QueryTableNamesHandler do
        let(:registry) { TableRegistry.new }
        let(:input) { ThroughputText.new(original_text: text, table_registry: registry) }
        let(:handler) { described_class.new(input: input, table_registry: registry) }
        let(:text) { "" }
        subject { handler }

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
              let(:text) { "+/#{grep}/"}
              subject { handler.lines.map(&:to_s) }
              it { is_expected.to eq(expected) }
            end
          end
        end
      end
    end
  end
end
