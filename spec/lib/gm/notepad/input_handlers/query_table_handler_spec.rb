require 'spec_helper'
require 'gm/notepad/input_handlers/query_table_handler'
require 'gm/notepad/table_registry'
require 'gm/notepad/table_entry'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe QueryTableHandler do
        let(:table_name) { 'programming' }
        let(:registry) { TableRegistry.new(config: Configuration.defaults_for(:paths, :table_extension, :filesystem_directory)) }
        let(:input) { '' }
        let(:handler) { described_class.new(input: input, table_registry: registry) }
        subject { handler }
        its(:to_interactive) { is_expected.to be_truthy }
        its(:to_filesystem) { is_expected.to be_falsey }
        its(:to_output) { is_expected.to be_falsey }
        its(:expand_line?) { is_expected.to be_falsey }

        describe ".handles?" do
          subject { described_class }
          it { is_expected.not_to handle("+/") }
          it { is_expected.not_to handle("?") }
          it { is_expected.not_to handle("+") }
          it { is_expected.to handle("+some") }
        end

        describe '#lines' do
          context "with a missing table_name" do
            let(:input) { '+o' }
            before do
              registry.register_by_string(table_name: "other", string: "1|Other")
            end
            it "will return a message saying its missing and provide a list of matches" do
              expect(handler.lines).to eq(
                ['Unknown table "o". Did you mean: "other"']
              )
            end
          end
          [
            [
              ["1|Hello {bork}", "2|World"],
              "+programming[1]",
              [TableEntry.new(line: "1|Hello {bork}")]
            ],[
              ["1|Hello {bork}", "2|World"],
              "+programming[]",
              [TableEntry.new(line: "1|Hello {bork}"), TableEntry.new(line: "2|World")]
            ],[
              ["1|Hello {bork}", "2|World"],
              "+programming[75]",
              [%(Entry with index "75" not found in "programming" table)]
            ],[
              ["1|Hello {bork}", "2|World"],
              "+programming/world/",
              [TableEntry.new(line: "2|World")]
            ],[
              ["1|Hello {bork}", "2|World"],
              "+programming/{bork}/",
              [TableEntry.new(line: "1|Hello {bork}")]
            ],[
              ["1|Hello {bork}", "2|World"],
              "+programming//",
              [TableEntry.new(line: "1|Hello {bork}"), TableEntry.new(line: "2|World")]
            ],[
              ["1|Hello {bork}", "2|World"],
              "+programming/o/",
              [TableEntry.new(line: "1|Hello {bork}"), TableEntry.new(line: "2|World")]
            ]
          ].each_with_index do |(table, given, expected), index|
            context "with #{given.inspect} for table: #{table.inspect} (scenario ##{index})" do
              before do
                registry.register_by_string(table_name: table_name, string: table.join("\n"))
              end
              let(:input) { given }
              subject { handler.lines }
              it { is_expected.to eq(expected) }
            end
          end
        end
      end
    end
  end
end
