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
          "INDEX | City",
          "1| Tokyo",
          "2| Berlin",
          "3-4| Dhaka",
          "5-10| Mumbai"
        ]
      end
      let(:filename) { nil }
      let(:table) { described_class.new(table_name: table_name, lines: lines, filename: filename) }

      [
        {
          lines: ["# Comment", "INDEX | City", "1 | Tokyo", "2 | Berlin", "3-4 | Dhaka", "5-10 | Mumbai"],
          all: ["Tokyo", "Berlin", "Dhaka", "Mumbai"],
          column_names: ["city"]
        },{
          lines: ["# Comment", "INDEX | City | Country", "1 | Tokyo | Japan", "2 | Berlin | Germany", "3-4 | Dhaka | Bangladesh", "5-10 | Mumbai | India"],
          all: ["Tokyo\tJapan", "Berlin\tGermany", "Dhaka\tBangladesh", "Mumbai\tIndia"],
          column_names: ["city", "country"]
        },{
          lines: ["# Comment", "1 | Tokyo | Japan", "2 | Berlin | Germany", "3-4 | Dhaka | Bangladesh", "5-10 | Mumbai | India"],
          all: ["Tokyo\tJapan", "Berlin\tGermany", "Dhaka\tBangladesh", "Mumbai\tIndia"],
          column_names: []
        }
      ].each_with_index do |spec_config, index|
        describe "with table: #{spec_config.fetch(:lines).join(" \\n ")}" do
          let(:lines) { spec_config.fetch(:lines) }
          subject { table }
          its(:all) { is_expected.to eq(spec_config.fetch(:all)) }
          its(:column_names) { is_expected.to eq(spec_config.fetch(:column_names)) }
        end
      end

      describe "#lookup" do
        describe "when a line has 'or more'" do
          let(:lines) { ["# Comment", "1 or less | Small", "2 | Medium", "3 or more | Large"] }
          it "with an or more" do
            expect(table.lookup(index: "1").to_s).to eq("[1 or less]\tSmall")
            expect(table.lookup(index: "2").to_s).to eq("[2]\tMedium")
            expect(table.lookup(index: "-1").to_s).to eq("[1 or less]\tSmall")
            expect(table.lookup(index: "3").to_s).to eq("[3 or more]\tLarge")
            expect(table.lookup(index: "4").to_s).to eq("[3 or more]\tLarge")
          end
        end
      end

      context "when initialized with a table that has overlap" do
        subject { table }
        let(:lines) { ["1|a", "1|b"] }
        it 'raises an exception' do
          expect { subject }.to raise_error(/Duplicate key/)
        end
      end

      describe '#append' do
        subject { table }
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
        let(:lines) do
          ["1 | Tokyo | Japan","2 | Berlin | Germany","3-4 | Dhaka | Bangladesh","5-10 | Mumbai | India"]
        end
        subject { table }
        it "allows for lookup by index" do
          expect(subject.lookup(index: "1").to_s).to eq("[1]\tTokyo\tJapan")
          expect(subject.lookup(index: "7").to_s).to eq("[5-10]\tMumbai\tIndia")
        end

        describe 'by index and by cell' do
          describe 'with un-named columns' do
            it "treats for lookup by index and cell" do
              expect(subject.lookup(index: "1", cell: "1").to_s).to eq("Tokyo")
              expect(subject.lookup(index: "7", cell: "2").to_s).to eq("India")
            end
          end
          describe 'with named columns' do
            let(:lines) do
              ["INDEX | City | Country", "1 | Tokyo | Japan","2 | Berlin | Germany","3-4 | Dhaka | Bangladesh","5-10 | Mumbai | India"]
            end

            it "treats uses the named cell" do
              expect(subject.lookup(index: "1", cell: "city").to_s).to eq("Tokyo")
              expect(subject.lookup(index: "7", cell: "country").to_s).to eq("India")
            end

            it "treats can fall back to the ordinal" do
              expect(subject.lookup(index: "1", cell: "1").to_s).to eq("Tokyo")
              expect(subject.lookup(index: "7", cell: "country").to_s).to eq("India")
            end
          end
        end

        it "raises MissingTableEntryError for missing index" do
          expect { subject.lookup(index: "0") }.to raise_error(MissingTableEntryError)
        end

        it "will use a random value (within range) for the index" do
          expect(subject.lookup).to be_a(TableEntry::Base)
        end

        it 'will not register lines starting with "#"' do
          expect { subject.lookup(index: "#") }.to raise_error(MissingTableEntryError)
        end
      end
    end
  end
end
