require 'spec_helper'
require 'gm/notepad/table'
require 'fileutils'
module Gm
  module Notepad
    RSpec.describe Table do
      let(:table_name) { "city" }
      let(:lines) do
        [
          "1| Tokyo",
          "2| Berlin",
          "3-4| Dhaka",
          "5-10| Mumbai"
        ]
      end
      subject { described_class.new(table_name: table_name, lines: lines) }

      context "when initialized with a table that has overlap" do
        it 'raises an exception' do
          expect { described_class.new(table_name: table_name, lines: ["1|a", "1|b"]) }.to raise_error(/Duplicate key/)
        end
      end

      describe '#append' do
        context "without file" do
          it "adds records to the table" do
            subject.append(line: "a| Sao Paulo")
            expect(subject.lookup(index: "a").to_s).to eq("Sao Paulo")
          end
        end
        context "with underlying file" do
          subject do
            described_class.new(
              table_name: table_name,
              lines: File.read(filename).split("\n"),
              filename: filename
            )
          end
          let(:filename) { File.join(PATH_TO_FIXTURES, "spec-data.txt") }
          before do
            File.open(filename, "w+") do |file|
              file.puts "a | Hello"
            end
          end
          after do
            FileUtils.rm(filename)
          end
          it "will append the line" do
            subject.append(line: "1 | World", write: true)
            expect(subject.lookup(index: "1").to_s).to eq("World")
            expect(File.read(filename).to_s).to eq("a | Hello\n1 | World\n")
          end
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
          expect(subject.lookup).to be_a(TableEntry)
        end
      end
    end
  end
end
