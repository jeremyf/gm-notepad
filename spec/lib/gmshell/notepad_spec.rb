require 'spec_helper'
require 'gmshell/notepad'
module Gmshell
  RSpec.describe Notepad do
    its(:default_table_registry) { is_expected.to respond_to(:evaluate) }
    its(:default_interactive_buffer) { is_expected.to respond_to(:puts) }
    its(:default_output_buffer) { is_expected.to respond_to(:puts) }
    its(:default_renderer) { is_expected.to respond_to(:call) }

    let(:timestamp) { true }
    let(:table_registry) { double("table registry") }
    let(:first_line) { "this line is my line" }
    let(:second_line) { "this line is your line" }
    let(:renderer) { double("renderer") }

    let(:notepad) do
      described_class.new(
        skip_config_reporting: true,
        timestamp: true,
        renderer: renderer,
        table_registry: table_registry
      )
    end

    before do
      allow(table_registry).to receive(:evaluate).with(line: first_line).and_return(first_line)
      allow(table_registry).to receive(:evaluate).with(line: second_line).and_return(second_line)
      allow(renderer).to receive(:call)
    end

    describe '#log' do
      subject { notepad.log(first_line) }
      it 'will call the renderer' do
        expect(renderer).to receive(:call).with(first_line, to_interactive: true, to_output: false)
        subject
      end
    end
  end
end
