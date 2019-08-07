require 'spec_helper'
require 'gm/notepad/readline'
require 'gm/notepad/table_registry'

module Gm
  module Notepad
    RSpec.describe Readline do
      describe '#input_getter' do
        subject { described_class.input_getter }
        it { is_expected.to respond_to(:call) }
      end
      describe '#completion_function' do
        let(:table_registry) { TableRegistry.new }
        let(:tables) do
          [
            { table_name: "programming", string: "1|Hello\n2|World" },
            { table_name: "roman", string: "1|I\n2|II" },
            { table_name: "month", string: "7|July\n8|August" }
          ]
        end
        before do
          tables.each do |table|
            table_registry.register_by_string(**table)
          end
        end
        it "will lookup tables" do
          expect(described_class.completion_function("+p", table_registry: table_registry)).to eq(["+programming"])
          expect(described_class.completion_function("+", table_registry: table_registry)).to eq(["+month", "+programming", "+roman"])
        end
        it "will expand tables" do
          expect(described_class.completion_function("Lovely {mo", table_registry: table_registry)).to eq(["Lovely {month}"])
        end
        it "will blend history and tables" do
          expect(described_class).to receive(:history_for).with("+p").and_return(["+parrots"])
          expect(described_class.completion_function("+p", table_registry: table_registry)).to eq(["+parrots", "+programming"])
        end
      end
    end
  end
end
