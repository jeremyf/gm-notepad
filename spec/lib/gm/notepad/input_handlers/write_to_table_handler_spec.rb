require 'spec_helper'
require 'gm/notepad/input_handlers/write_to_table_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe WriteToTableHandler do
        let(:input) { "<table>" }
        let(:handler) { described_class.new(input: input) }
        subject { handler }
        its(:to_interactive) { is_expected.to be_truthy }
        its(:to_output) { is_expected.to be_falsey }
        its(:to_filesystem) { is_expected.to be_truthy }
      end
    end
  end
end
