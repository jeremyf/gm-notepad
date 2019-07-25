require 'spec_helper'
require 'gmshell/table_registry'
module Gmshell
  RSpec.describe TableRegistry do
    let(:tables) do
      [
        { term: "programming", string: "1|Hello\n2|World" },
        { term: "roman", string: "1|I\n2|II" }
      ]
    end

    subject { described_class.new }
    before do
      tables.each do |table|
        subject.register_by_string(**table)
      end
    end
    context '#lookup' do
      it "will use the term and lookup in the table" do
        expect(subject.lookup(term: "roman", index: "1").to_s).to eq("I")
      end
    end
  end
end
