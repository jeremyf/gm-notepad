require 'spec_helper'
require 'gm/notepad/line_evaluator'
require 'gm/notepad/table_registry'
module Gm
  module Notepad
    RSpec.describe LineEvaluator do
      describe "#call" do
        let(:table_registry) { TableRegistry.new }
        let(:time_to_live) { 3 }
        let(:line_evaluator) { described_class.new(table_registry: table_registry, time_to_live: time_to_live) }

        before do
          tables.each do |table|
            table_registry.register_by_string(**table)
          end
        end

        describe "with recursive table" do
          subject { line_evaluator.call(line: "{infinite}", expand_line: true) }
          let(:tables) { [{ table_name: "infinite", string: "1|{infinite}"}] }
          it { expect { subject }.to raise_error(ExceededTimeToLiveError) }
        end

        describe "successful scenarios with specific registered tables" do
          let(:tables) do
            [
              { table_name: "multi-column", string: "1|Cell 0|Cell 1"},
              { table_name: "inner", string: "1|resolved-inner" },
              { table_name: "resolved-inner-outer", string: "1|nested-resolve" },
              { table_name: "outer", string: "1|resolved-outer" },
              { table_name: "critical", string: "1|rolled on table\n1d1|did not roll on table" },
            ]
          end


          [
            ["{critical[1d1]}", "rolled on table", true],
            ["{critical[{3d1}]}", "Missing index \"3\" for table \"critical\"", true],
            ["{multi-column[][1]}", "Cell 0", true],
            ["{multi-column}", "Cell 0\tCell 1", true],
            ["{1d1}", "1", true],
            ["{hello} {world}", "{hello} {world}", false],
            ["{{inner}-outer}", "nested-resolve", true],
            ["{1d1}", "{1d1}", false]
          ].each do |given, expected, expand_line|
            describe "with line: #{given.inspect} and expand_line: #{expand_line}" do
              subject { line_evaluator.call(line: given, expand_line: expand_line).to_s }
              it { is_expected.to eq(expected) }
            end
          end
        end
      end
    end
  end
end
