require 'spec_helper'
require 'gmshell/table_registry'
module Gmshell
  RSpec.describe TableRegistry do
    let(:tables) do
      [
        { table_name: "programming", string: "1|Hello\n2|World" },
        { table_name: "roman", string: "1|I\n2|II" }
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
        expect(subject.table_names).to eq(["programming", "roman"])
      end
    end
    context '#fetch_table' do
      context 'for a valid table name' do
        it 'will return a table' do
          expect(subject.fetch_table(name: "roman")).to be_a(Table)
        end
      end
      context 'for a invalid table name' do
        it 'will raise a KeyError' do
          expect { subject.fetch_table(name: "missing") }.to raise_error(KeyError)
        end
      end
    end
    context '#lookup' do
      it "will use the table_name and lookup in the table" do
        expect(subject.lookup(table_name: "roman", index: "1").to_s).to eq("I")
      end
    end
  end
end
