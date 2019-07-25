require 'spec_helper'
require 'gmshell/input_handlers/help_handler'

module Gmshell
  module InputHandlers
    RSpec.describe HelpHandler do
      let(:notepad) { double("notepad") }
      context '#call' do
        it "logs an array of helpful messages" do
          expect(described_class.call).to be_a(Array)
        end
      end
    end
  end
end
