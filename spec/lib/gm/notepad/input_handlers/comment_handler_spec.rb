require 'spec_helper'
require 'gm/notepad/input_handlers/comment_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe CommentHandler do
        let(:handler) { described_class.new(input: input) }
        let(:input) { "# comment" }
        subject { handler }
        its(:to_interactive) { is_expected.to be_truthy }
        its(:to_output) { is_expected.to be_falsey }
        its(:to_filesystem) { is_expected.to be_falsey }
        its(:expand_line?) { is_expected.to be_falsey }
        context '#lines' do
          subject { handler.lines }
          it "logs an array of helpful messages" do
            is_expected.to eq([input])
          end
        end
      end
    end
  end
end
