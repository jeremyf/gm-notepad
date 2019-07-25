require 'spec_helper'
require 'gmshell/message_context'

module Gmshell
  RSpec.describe MessageContext do
    subject { described_class.new(input: "hello", handler: :work, hello: {}) }
    it { is_expected.to respond_to :input }
    it { is_expected.to respond_to :handler }
    it { is_expected.to respond_to :parameters }
  end
end
