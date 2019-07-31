require 'spec_helper'
require 'gm/notepad/input_handlers/write_to_table_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe WriteToTableHandler do
        let(:input) { "#{described_class::HANDLED_PREFIX}table:" }
        let(:handler) { described_class.new(input: input) }
        subject { handler }

        xit "will write to files"
      end
    end
  end
end
