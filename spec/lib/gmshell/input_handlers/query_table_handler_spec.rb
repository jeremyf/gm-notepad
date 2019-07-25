require 'spec_helper'
require 'gmshell/input_handlers/query_table_handler'
require 'gmshell/table_registry'
require 'gmshell/table_entry'

module Gmshell
  module InputHandlers
    RSpec.describe QueryTableHandler do
      let(:table_name) { 'programming' }
      let(:registry) { Gmshell::TableRegistry.new }
      let(:input) { '' }
      let(:handler) { described_class.new(input: input, table_registry: registry) }
      subject { handler }
      its(:to_interactive) { is_expected.to be_truthy }
      its(:to_output) { is_expected.to be_falsey }
      its(:expand_line?) { is_expected.to be_falsey }

      describe '#lines' do
        context "with a missing table_name" do
          let(:input) { '+o' }
          let(:registry) do
            Gmshell::TableRegistry.new.tap do |r|
              r.register_by_string(table_name: "other", string: "1|Other")
            end
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
            [Gmshell::TableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            "+programming/world/",
            [Gmshell::TableEntry.new(line: "2|World")]
          ],[
            ["1|Hello {bork}", "2|World"],
            "+programming/{bork}/",
            [Gmshell::TableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            "+programming/o/",
            [Gmshell::TableEntry.new(line: "1|Hello {bork}"), Gmshell::TableEntry.new(line: "2|World")]
          ]
        ].each_with_index do |(table, given, expected), index|
          context "with #{given.inspect} for table: #{table.inspect} (scenario ##{index})" do
            let(:registry) do
              Gmshell::TableRegistry.new.tap do |r|
                r.register_by_string(table_name: table_name, string: table.join("\n"))
              end
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
