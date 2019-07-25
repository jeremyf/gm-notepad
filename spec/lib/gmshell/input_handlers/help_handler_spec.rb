require 'spec_helper'
require 'gmshell/input_handlers/help_handler'

module Gmshell
  module InputHandlers
    RSpec.describe HelpHandler do
      let(:handler) { described_class.new(input: nil) }
      context '#call' do
        subject { handler.call }
        it "logs an array of helpful messages" do
          is_expected.to be_a(Array)
        end
      end
    end
  end
end
