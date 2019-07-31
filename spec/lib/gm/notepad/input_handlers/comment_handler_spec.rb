require 'spec_helper'
require 'gm/notepad/input_handlers/comment_handler'

module Gm
  module Notepad
    module InputHandlers
      RSpec.describe CommentHandler do
        let(:handler) { described_class.new(input: input) }
        let(:input) { "# comment" }
        subject { handler }
        context '#lines' do
          subject { handler.lines.map(&:to_s) }
          it "logs an array of helpful messages" do
            is_expected.to eq([input])
          end
        end
        describe '.handles?' do
          subject { described_class }
          it { is_expected.to handle("#") }
          it { is_expected.not_to handle("a#") }
        end
      end
    end
  end
end
