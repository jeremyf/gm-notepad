require 'spec_helper'
require 'gmshell/input_processing_context'

module Gmshell
  RSpec.describe InputProcessingContext do
    subject { described_class.new(input: "hello", handler_name: :work, hello: {}) }
    it { is_expected.to respond_to :input }
    it { is_expected.to respond_to :handler_name }
    it { is_expected.to respond_to :parameters }
  end
end
