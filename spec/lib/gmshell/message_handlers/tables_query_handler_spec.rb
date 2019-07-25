require 'spec_helper'
require 'gmshell/message_handlers/tables_query_handler'

module Gmshell
  module MessageHandlers
    RSpec.describe TablesQueryHandler do
      describe '#call' do
        [
          [['abc', 'daz', 'bcd', 'def', 'xyz'], 'a\w', ['abc', 'daz']],
          [['abc', 'daz', 'bcd', 'def', 'xyz'], nil, ['abc', 'daz', 'bcd', 'def', 'xyz'].sort],
          [['abc', 'daz', 'bcd', 'def', 'xyz'], '^a', ['abc']]
        ].each_with_index do |(terms, grep, expected), index|
          context "for terms: #{terms.inspect}, grep: #{grep.inspect} (index: #{index})" do
            let(:registry) { double("registry", terms: terms) }
            subject { described_class.call(grep: grep, registry: registry) }
            it { is_expected.to eq(expected) }
          end
        end
      end
    end
  end
end
