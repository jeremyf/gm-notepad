require 'spec_helper'
require 'gmshell/table_entry'
module Gmshell
  RSpec.describe TableEntry do
    context 'for line of "1| Tokyo"' do
      let(:line) { "1#{TABLE_ENTRY_SEPARATOR} Tokyo" }
      subject { described_class.new(line: line) }
      its(:entry_column) { is_expected.to eq("Tokyo") }
      its(:lookup_range) { is_expected.to eq(["1"]) }
    end
    context 'for line of "1-2| Tokyo"' do
      let(:line) { "1-2#{TABLE_ENTRY_SEPARATOR} Tokyo" }
      subject { described_class.new(line: line) }
      its(:entry_column) { is_expected.to eq("Tokyo") }
      its(:lookup_column) { is_expected.to eq("1-2") }
      its(:lookup_range) { is_expected.to eq(["1","2"]) }
    end
    context 'for line of "a-2| Tokyo"' do
      let(:line) { "a-2#{TABLE_ENTRY_SEPARATOR} Tokyo" }
      subject { described_class.new(line: line) }
      its(:entry_column) { is_expected.to eq("Tokyo") }
      its(:lookup_column) { is_expected.to eq("a-2") }
      its(:lookup_range) { is_expected.to eq(["a-2"]) }
    end
  end
end
