require 'spec_helper'
require 'gmshell/message_handlers/query_handler'
require 'gmshell/term_registry'
require 'gmshell/term_table_entry'

module Gmshell
  module MessageHandlers
    RSpec.describe QueryHandler do
      let(:term) { 'programming' }
      describe '#call' do
        [
          [
            ["1|Hello {bork}", "2|World"],
            { index: "1", expand: false },
            [Gmshell::TermTableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "world", expand: false },
            [Gmshell::TermTableEntry.new(line: "2|World")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "{bork}", expand: false },
            [Gmshell::TermTableEntry.new(line: "1|Hello {bork}")]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "{bork}", expand: true },
            ["Hello (undefined bork)"]
          ],[
            ["1|Hello {bork}", "2|World"],
            { grep: "o", expand: true },
            ["Hello (undefined bork)", "World"]
          ]
        ].each_with_index do |(table, given, expected), index|
          context "with #{given.inspect} for table: #{table.inspect} (scenario ##{index})" do
            let(:registry) do
              Gmshell::TermRegistry.new.tap do |registry|
                registry.register_by_string(term: term, string: table.join("\n"))
              end
            end
            subject { described_class.call(registry: registry, term: term, **given) }
            it { is_expected.to eq(expected) }
          end
        end
      end
    end
  end
end
