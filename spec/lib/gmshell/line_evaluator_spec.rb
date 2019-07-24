require 'spec_helper'
require 'gmshell/line_evaluator'
module Gmshell
  RSpec.describe LineEvaluator do
    before do
      @counter = 0
    end
    let(:term_evaluation_function) { ->(term:) { "(#{term}:#{@counter+=1})" } }
    subject { described_class.new }
    describe "#call (using evaluator that surrounds in paranthesises and increments a counter)" do
      [
        ["{hello} {world}", "(hello:1) (world:2)"],
        ["{hello{world}}", "(hello(world:1):2)"],
        ["{hello} {hello}", "(hello:1) (hello:2)"],
        ["[1d1]", "1 (1d1)"],
        ["[taco]", "(taco)"],
        ["[taco]{hello}", "(taco)(hello:1)"]
      ].each do |given, expected|
        it "evaluates #{given.inspect} as #{expected.inspect}" do
          expect(subject.call(line: given, term_evaluation_function: term_evaluation_function)).to eq(expected)
        end
      end
    end
  end
end
