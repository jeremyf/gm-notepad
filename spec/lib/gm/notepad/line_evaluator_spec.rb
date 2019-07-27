require 'spec_helper'
require 'gm/notepad/line_evaluator'
require 'gm/notepad/table_registry'
module Gm
  module Notepad
    RSpec.describe LineEvaluator do
      before do
        @counter = 0
      end
      let(:tables) do
        [
          { table_name: "hello", string: "1|hello:1" },
          { table_name: "world", string: "1|world:1" },
          { table_name: "helloworld:1", string: "1|nested" },
          { table_name: "inner", string: "1|resolved-inner" },
          { table_name: "resolved-inner-outer", string: "1|nested-resolve" },
          { table_name: "outer", string: "1|resolved-outer" },
          { table_name: "critical", string: "1|rolled on table\n1d1|did not roll on table" },
        ]
      end
      let(:table_registry) { TableRegistry.new }
      before do
        tables.each do |table|
          table_registry.register_by_string(**table)
        end
      end
      subject { described_class.new(table_registry: table_registry) }
      describe "#call" do
        [
          ["{critical[1d1]}", "rolled on table", true],
          ["{hello} {world}", "hello:1 world:1", true],
          ["{hello{world}}", "nested", true],
          ["{hello} {hello}", "hello:1 hello:1", true],
          ["[1d1]", "1", true],
          # ["[taco]", "(taco)", true],
          ["[taco]{hello}", "(taco)hello:1", true],
          ["{hello} {world}", "{hello} {world}", false],
          ["{hello{world}}", "{hello{world}}", false],
          ["{{inner}-outer}", "nested-resolve", true],
          ["[1d1]", "[1d1]", false],
          ["[taco]", "[taco]", false],
          ["[taco]{hello}", "[taco]{hello}", false],
        ].each do |given, expected, expand_line|
          it "evaluates #{given.inspect} as #{expected.inspect} (for expand_line: #{expand_line})" do
            expect(
              subject.call(
                line: given,
                expand_line: expand_line
              )
            ).to eq(expected)
          end
        end
      end
    end
  end
end
