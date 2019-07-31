require 'spec_helper'
require 'gm/notepad/input_handlers/help_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe HelpHandler do
        let(:table_registry) { double("Table Registry") }
        let(:input) { ThroughputText.new(original_text: "?", table_registry: table_registry) }
        let(:handler) { described_class.new(input: input, table_registry: table_registry) }
        subject { handler }


        describe ".handles?" do
          subject { described_class }
          it { is_expected.not_to handle("+?") }
          it { is_expected.to handle("?") }
          it { is_expected.to handle("?hello") }
        end


        it "updates the throughput text for rendering" do
          expect(input).to receive(:for_rendering).with(text: kind_of(String), to_interactive: true, to_output: false, expand_line: false).at_least(7).times
          subject
        end
      end
    end
  end
end
