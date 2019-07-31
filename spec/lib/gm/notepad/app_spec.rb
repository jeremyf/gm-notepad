require 'spec_helper'
require 'gm/notepad/app'
module Gm
  module Notepad
    RSpec.describe App do
      let(:first_line) { "this line is my line" }
      let(:second_line) { "this line is your line" }
      let(:renderer) { double("renderer") }
      let(:input_processor) { double("input processor") }

      let(:notepad) do
        described_class.new(renderer: renderer, input_processor: input_processor)
      end

      before do
        allow(renderer).to receive(:render)
        allow(renderer).to receive(:call)
        allow(renderer).to receive(:process)
      end

      describe '#process' do
        subject { notepad.process(text: first_line) }
        it 'will call the input processor' do
          expect(input_processor).to receive(:process).with(input: kind_of(ThroughputText))
          subject
        end
      end
    end
  end
end
