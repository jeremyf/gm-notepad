require 'spec_helper'
require 'gm/notepad/input_processing_context'

module Gm
  module Notepad
    RSpec.describe InputProcessingContext do
      subject { described_class.new(input: "hello", handler_name: :work, hello: {}) }
      it { is_expected.to respond_to :input }
      it { is_expected.to respond_to :handler_name }
      it { is_expected.to respond_to :parameters }
    end
  end
end
