require 'spec_helper'
require 'gmshell/term_table_entry'
module Gmshell
  RSpec.describe TermTableEntry do
    context 'for line of "1| Tokyo"' do
      let(:line) { "1#{TERM_TABLE_ENTRY_SEPARATOR} Tokyo" }
      subject { described_class.new(line: line) }
      its(:entry_column) { is_expected.to eq("Tokyo") }
      its(:lookup_range) { is_expected.to eq((1..1)) }
    end
    context 'for line of "1-2| Tokyo"' do
      let(:line) { "1-2#{TERM_TABLE_ENTRY_SEPARATOR} Tokyo" }
      subject { described_class.new(line: line) }
      its(:entry_column) { is_expected.to eq("Tokyo") }
      its(:lookup_column) { is_expected.to eq("1-2") }
      its(:lookup_range) { is_expected.to eq((1..2)) }
    end
  end
end
