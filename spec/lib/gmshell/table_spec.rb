require 'spec_helper'
require 'gmshell/table'
module Gmshell
  RSpec.describe Table do
    let(:term) { "city" }
    let(:lines) do
      [
        "1| Tokyo",
        "2| Berlin",
        "3-4| Dhaka",
        "5-10| Mumbai"
      ]
    end
    let(:subject) { described_class.new(term: term, lines: lines) }

    context "when initialized with a table that has overlap" do
      it 'raises an exception' do
        expect { described_class.new(term: term, lines: ["1|a", "1|b"]) }.to raise_error(/Duplicate key/)
      end
    end

    context "#lookup" do
      it "allows for lookup by index" do
        expect(subject.lookup(index: "1").to_s).to eq("Tokyo")
        expect(subject.lookup(index: "7").to_s).to eq("Mumbai")
      end

      it "raises KeyError for missing index" do
        expect { subject.lookup(index: "0") }.to raise_error(KeyError)
      end

      it "will use a random value (within range) for the index" do
        expect(subject.lookup).to be_a(TermTableEntry)
      end
    end
  end
end
