require 'spec_helper'
require 'gmshell/input_handlers/query_table_names_handler'

module Gmshell
  module InputHandlers
    RSpec.describe QueryTableNamesHandler do
      let(:handler) { described_class.new(input: nil) }
      subject { handler }
      its(:to_interactive) { is_expected.to be_truthy }
      its(:to_output) { is_expected.to be_falsey }
      its(:expand_line?) { is_expected.to be_falsey }

      describe '#call' do
        [
          [['abc', 'daz', 'bcd', 'def', 'xyz'], 'a\w', ['abc', 'daz']],
          [['abc', 'daz', 'bcd', 'def', 'xyz'], nil, ['abc', 'daz', 'bcd', 'def', 'xyz'].sort],
          [['abc', 'daz', 'bcd', 'def', 'xyz'], '^a', ['abc']]
        ].each_with_index do |(table_names, grep, expected), index|
          context "for table_names: #{table_names.sort.inspect}, grep: #{grep.inspect} (index: #{index})" do
            let(:registry) { double("registry", table_names: table_names.sort) }
            subject { handler.call(grep: grep, registry: registry) }
            it { is_expected.to eq(expected) }
          end
        end
      end
    end
  end
end
