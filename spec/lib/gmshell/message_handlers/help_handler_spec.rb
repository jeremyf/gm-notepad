require 'spec_helper'
require 'gmshell/message_handlers/help_handler'

module Gmshell
  module MessageHandlers
    RSpec.describe HelpHandler do
      let(:notepad) { double("notepad") }
      context '#call' do
        it "logs an array of helpful messages" do
          expect(notepad).to receive(:log).with(kind_of(Array), expand: false)
          described_class.call(notepad: notepad, expand: false)
        end
      end
    end
  end
end
