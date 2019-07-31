require 'spec_helper'
require 'gm/notepad/input_handlers/comment_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe CommentHandler do
        let(:table_registry) { double("Table Registry") }
        let(:handler) { described_class.new(input: input, table_registry: table_registry) }
        let(:input) { ThroughputText.new(original_text: "# comment", table_registry: table_registry) }
        subject { handler }
        describe '.handles?' do
          subject { described_class }
          it { is_expected.to handle("#") }
          it { is_expected.not_to handle("a#") }
        end

        it "updates the throughput text for rendering" do
          expect(input).to receive(:render_current_text).with(to_interactive: true, to_output: false, expand_line: false).and_call_original
          subject
        end
      end
    end
  end
end
