require 'spec_helper'
require 'gm/notepad/input_handlers/write_line_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe WriteLineHandler do
        let(:input) { "" }
        let(:handler) { described_class.new(input: input) }
        subject { handler }
        its(:to_interactive) { is_expected.to be_truthy }
        its(:to_output) { is_expected.to be_truthy }
        its(:to_filesystem) { is_expected.to be_falsey }
        context "when input starts with !" do
          let(:input) { "!" }
          its(:expand_line?) { is_expected.to be_falsey }
        end
        context "when input starts with !" do
          let(:input) { "" }
          its(:expand_line?) { is_expected.to be_truthy }
        end
      end
    end
  end
end