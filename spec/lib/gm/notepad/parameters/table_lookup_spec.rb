require 'spec_helper'
require 'gm/notepad/parameters/table_lookup'

module Gm
  module Notepad
    module Parameters
      RSpec.describe TableLookup do
        describe "#parameters" do
          [
            ["name", { table_name: "name" }],
            ["name[1]", { index: "1", table_name: "name" }],
            ["name/h/", { grep: "h", table_name: "name" }],
            ["name//", { table_name: "name" }],
            ["name[]", { table_name: "name" }],
            ["name[1d1]", { index: "1d1", table_name: "name" }],
            ["name[{1d1}]", { index: "{1d1}", table_name: "name" }],
            ["name[{1d1}]//", { index: "{1d1}", table_name: "name//" }],
            ["name[{1d1}][1d1]", { cell: "1d1", index: "{1d1}", table_name: "name" }],
            ["name[{1d1}][1d1]", { cell: "1d1", index: "{1d1}", table_name: "name" }],
          ].each_with_index do |(given, expected), index|
            describe "with { text: #{given.inspect} } (scenario #{index})" do
              subject { described_class.new(text: given).parameters }
              it { is_expected.to eq(expected) }
            end
          end
        end
      end
    end
  end
end
