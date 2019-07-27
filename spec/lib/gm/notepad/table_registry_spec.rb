require 'spec_helper'
require 'gm/notepad/table_registry'
module Gm
  module Notepad
    RSpec.describe TableRegistry do
      let(:tables) do
        [
          { table_name: "programming", string: "1|Hello\n2|World" },
          { table_name: "roman", string: "1|I\n2|II" },
          { table_name: "MONTH", string: "7|July\n8|August" }
        ]
      end

      let(:subject) { described_class.new }
      before do
        tables.each do |table|
          subject.register_by_string(**table)
        end
      end
      it "will raise an error if you try to re-register" do
        table = tables.first
        expect { subject.register_by_string(**table) }.to raise_error DuplicateKeyError
      end
      context '#table_names' do
        it "will be the table names for those tables registered" do
          expect(subject.table_names).to eq([ "month", "programming", "roman"])
        end
      end
      context '#fetch_table' do
        context 'for a valid table name' do
          it 'will return a table' do
            expect(subject.fetch_table(name: "roman")).to be_a(Table)
            expect(subject.fetch_table(name: "ROMAN")).to be_a(Table)
          end
        end
        context 'for a invalid table name' do
          it 'will raise a MissingTableError' do
            expect { subject.fetch_table(name: "missing") }.to raise_error(MissingTableError)
          end
        end
      end
      context '#lookup' do
        it "will use the table_name and lookup in the table" do
          expect(subject.lookup(table_name: "roman", index: "1").to_s).to eq("[1]\tI")
        end
      end
    end
  end
end
