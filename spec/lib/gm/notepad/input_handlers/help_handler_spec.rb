require 'spec_helper'
require 'gm/notepad/input_handlers/help_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe HelpHandler do
        let(:handler) { described_class.new(input: "?") }
        subject { handler }
        its(:to_interactive) { is_expected.to be_truthy }
        its(:to_output) { is_expected.to be_falsey }
        its(:to_filesystem) { is_expected.to be_falsey }
        its(:expand_line?) { is_expected.to be_falsey }

        describe ".handles?" do
          subject { described_class }
          it { is_expected.not_to handle("+?") }
          it { is_expected.to handle("?") }
          it { is_expected.to handle("?hello") }
        end

        context '#lines' do
          subject { handler.lines }
          it "logs an array of helpful messages" do
            is_expected.to be_a(Array)
          end
        end
      end
    end
  end
end
