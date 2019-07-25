require 'spec_helper'
require 'gmshell/input_handlers/help_handler'

module Gmshell
  module InputHandlers
    RSpec.describe HelpHandler do
      let(:handler) { described_class.new(input: nil) }
      subject { handler }
      its(:to_interactive) { is_expected.to be_truthy }
      its(:to_output) { is_expected.to be_falsey }
      its(:expand_line?) { is_expected.to be_falsey }
      context '#lines' do
        subject { handler.lines }
        it "logs an array of helpful messages" do
          is_expected.to be_a(Array)
        end
      end
    end
  end
end
