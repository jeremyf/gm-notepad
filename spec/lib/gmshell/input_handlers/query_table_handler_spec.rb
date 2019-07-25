require 'spec_helper'
require 'gmshell/input_handlers/query_table_handler'
require 'gmshell/table_registry'
require 'gmshell/table_entry'

module Gmshell
  module InputHandlers
    RSpec.describe QueryTableHandler do
      let(:table_name) { 'programming' }
      let(:handler) { described_class.new(input: '') }
      subject { handler }
      its(:to_interactive) { is_expected.to be_truthy }
      its(:to_output) { is_expected.to be_falsey }
      its(:expand_line?) { is_expected.to be_falsey }

      describe '#call' do
        context "with a missing table_name" do
          let(:registry) do
            Gmshell::TableRegistry.new.tap do |registry|
              registry.register_by_string(table_name: "other", string: "1|Other")
            end
          end
          it "will return a message saying its missing and provide a list of matches" do
            expect(handler.call(registry: registry, table_name: "o")).to eq(
              ['Unknown table "o". Did you mean: "other"']
            )
          end
        end
        [
          [
            ["1|Hello {bork}", "2|World"],
            { index: "1", expand_line: false },
            [Gmshell::TableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "world", expand_line: false },
            [Gmshell::TableEntry.new(line: "2|World")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "{bork}", expand_line: false },
            [Gmshell::TableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "{bork}", expand_line: true },
            [Gmshell::TableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "o", expand_line: true },
            [Gmshell::TableEntry.new(line: "1|Hello {bork}"), Gmshell::TableEntry.new(line: "2|World")]
          ]
        ].each_with_index do |(table, given, expected), index|
          context "with #{given.inspect} for table: #{table.inspect} (scenario ##{index})" do
            let(:registry) do
              Gmshell::TableRegistry.new.tap do |registry|
                registry.register_by_string(table_name: table_name, string: table.join("\n"))
              end
            end
            subject { handler.call(registry: registry, table_name: table_name, **given) }
            it { is_expected.to eq(expected) }
          end
        end
      end
    end
  end
end
