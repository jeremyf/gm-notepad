require 'spec_helper'
require 'gm/notepad/pad'
module Gm
  module Notepad
    RSpec.describe Pad do
      let(:config) do
        Configuration.new(
          table_registry: table_registry,
          renderer: renderer,
          input_processor: input_processor,
        )
      end

      let(:table_registry) { double("table registry") }
      let(:first_line) { "this line is my line" }
      let(:second_line) { "this line is your line" }
      let(:renderer) { double("renderer") }
      let(:input_processor) { double("input processor") }

      let(:notepad) do
        described_class.new(config: config)
      end

      before do
        allow(table_registry).to receive(:evaluate).with(line: first_line).and_return(first_line)
        allow(table_registry).to receive(:evaluate).with(line: second_line).and_return(second_line)
        allow(renderer).to receive(:call)
        allow(renderer).to receive(:process)
      end

      describe '#process' do
        subject { notepad.process(input: first_line) }
        it 'will call the input processor' do
          expect(input_processor).to receive(:process).with(input: first_line)
          subject
        end
      end
    end
  end
end
