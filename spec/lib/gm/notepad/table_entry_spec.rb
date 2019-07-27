require 'spec_helper'
require 'gm/notepad/table_entry'
module Gm
  module Notepad
    RSpec.describe TableEntry do
      context 'for line of "1| Tokyo | Japan"' do
        let(:line) { "1#{DEFAULT_COLUMN_DELIMITER} Tokyo#{DEFAULT_COLUMN_DELIMITER} Japan" }
        subject { described_class.new(line: line) }
        its(:entry_column) { is_expected.to eq("Tokyo\tJapan") }
        its(:cells) { is_expected.to eq(["Tokyo", "Japan"]) }
        its(:lookup_range) { is_expected.to eq(["1"]) }
      end
      context 'for line of "1| Tokyo"' do
        let(:line) { "1#{DEFAULT_COLUMN_DELIMITER} Tokyo" }
        subject { described_class.new(line: line) }
        its(:entry_column) { is_expected.to eq("Tokyo") }
        its(:cells) { is_expected.to eq(["Tokyo"]) }
        its(:lookup_range) { is_expected.to eq(["1"]) }
      end
      context 'for line of "1-2| Tokyo"' do
        let(:line) { "1-2#{DEFAULT_COLUMN_DELIMITER} Tokyo" }
        subject { described_class.new(line: line) }
        its(:entry_column) { is_expected.to eq("Tokyo") }
        its(:index) { is_expected.to eq("1-2") }
        its(:cells) { is_expected.to eq(["Tokyo"]) }
        its(:lookup_range) { is_expected.to eq(["1","2"]) }
      end
      context 'for line of "a-2| Tokyo"' do
        let(:line) { "a-2#{DEFAULT_COLUMN_DELIMITER} Tokyo" }
        subject { described_class.new(line: line) }
        its(:entry_column) { is_expected.to eq("Tokyo") }
        its(:index) { is_expected.to eq("a-2") }
        its(:cells) { is_expected.to eq(["Tokyo"]) }
        its(:lookup_range) { is_expected.to eq(["a-2"]) }
      end
      context 'for line of "A-2| Tokyo"' do
        let(:line) { "A-2#{DEFAULT_COLUMN_DELIMITER} Tokyo" }
        subject { described_class.new(line: line) }
        its(:entry_column) { is_expected.to eq("Tokyo") }
        its(:index) { is_expected.to eq("a-2") }
        its(:cells) { is_expected.to eq(["Tokyo"]) }
        its(:lookup_range) { is_expected.to eq(["a-2"]) }
      end
    end
  end
end
