require 'spec_helper'
require 'gm/notepad/table'
require 'fileutils'
module Gm
  module Notepad
    RSpec.describe Table do
      let(:table_name) { "city" }
      let(:lines) do
        [
          "# Table comments",
          "1| Tokyo",
          "2| Berlin",
          "3-4| Dhaka",
          "5-10| Mumbai"
        ]
      end
      let(:filename) { nil }
      subject { described_class.new(table_name: table_name, lines: lines, filename: filename) }

      context "when initialized with a table that has overlap" do
        let(:lines) { ["1|a", "1|b"] }
        it 'raises an exception' do
          expect { subject }.to raise_error(/Duplicate key/)
        end
      end

      describe '#append' do
        context "without file" do
          it "adds records to the table" do
            subject.append(line: "a| Sao Paulo")
            expect(subject.lookup(index: "a").to_s).to eq("[a]\tSao Paulo")
          end
        end
        context "with underlying file" do
          let(:lines) { File.read(filename).split("\n") }
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
            expect(subject.lookup(index: "1").to_s).to eq("[1]\tWorld")
            expect(File.read(filename).to_s).to eq("a | Hello\n1 | World\n")
          end
        end
      end

      context "#lookup" do
        it "allows for lookup by index" do
          expect(subject.lookup(index: "1").to_s).to eq("[1]\tTokyo")
          expect(subject.lookup(index: "7").to_s).to eq("[5-10]\tMumbai")
        end

        it "raises MissingTableEntryError for missing index" do
          expect { subject.lookup(index: "0") }.to raise_error(MissingTableEntryError)
        end

        it "will use a random value (within range) for the index" do
          expect(subject.lookup).to be_a(TableEntry)
        end

        it 'will not register lines starting with "#"' do
          expect { subject.lookup(index: "#") }.to raise_error(MissingTableEntryError)
        end
      end
    end
  end
end
