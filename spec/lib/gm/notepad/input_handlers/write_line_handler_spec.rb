require 'spec_helper'
require 'gm/notepad/input_handlers/write_line_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe WriteLineHandler do
        let(:table_registry) { double("Table Registry") }
        let(:input) { ThroughputText.new(original_text: text, table_registry: table_registry) }
        let(:handler) { described_class.new(input: input, table_registry: table_registry) }
        subject { handler }
        context "when input starts with !" do
          let(:text) { "!" }
          it 'will not expand the input' do
            expect(input).to receive(:render_current_text).with(to_interactive: true, to_output: true, expand_line: false)
            subject
          end
        end
        context "when input starts with !" do
          let(:text) { ("") }
          it 'will not expand the input' do
            expect(input).to receive(:render_current_text).with(to_interactive: true, to_output: true, expand_line: true)
            subject
          end
        end
      end
    end
  end
end
