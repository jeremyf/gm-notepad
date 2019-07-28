require 'spec_helper'
require 'gm/notepad/table_column_set'

module Gm
  module Notepad
    RSpec.describe TableColumnSet do
      let(:table) { double("table") }
      let(:table_column_set) { described_class.new(table: table, line: line ) }
      [
        { line: "INDEX_COLUMN | CITY | COUNTRY", names: ["city", "country"] },
        { line: "INDEX_COLUMN", names: [] },
      ].each do |entry|
        describe "with row #{entry[:line].inspect}" do
          describe "names#" do
            subject { table_column_set.names }
            let(:line) { entry[:line] }
            it { is_expected.to eq(entry[:names]) }
          end
        end
      end
    end
  end
end
