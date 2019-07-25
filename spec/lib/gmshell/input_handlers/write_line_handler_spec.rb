require 'spec_helper'
require 'gmshell/input_handlers/write_line_handler'

module Gmshell
  module InputHandlers
    RSpec.describe WriteLineHandler do
      let(:input) { "" }
      let(:handler) { described_class.new(input: input) }
      subject { handler }
      its(:to_interactive) { is_expected.to be_truthy }
      its(:to_output) { is_expected.to be_truthy }
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
