require 'spec_helper'
require 'gm/notepad/line_renderer'

module Gm
  module Notepad
    RSpec.describe LineRenderer do
      let(:interactive_buffer) { double("Interactive Buffer") }
      let(:output_buffer) { double("Interactive Buffer") }
      let(:line_renderer) do
        described_class.new(
          defer_output: defer_output,
          with_timestamp: with_timestamp
        )
      end

      [
        [
          { defer_output: true, with_timestamp: true },
          ["my_line", { to_output: true, to_interactive: true, as_of: "NOW" }],
          { output_buffer: [], interactive_buffer: ["=>\tmy_line"] }
        ],[
          { defer_output: false, with_timestamp: true },
          ["my_line", { to_output: true, to_interactive: true, as_of: "NOW" }],
          { output_buffer: ["NOW\tmy_line"], interactive_buffer: ["=>\tmy_line"] }
        ],[
          { defer_output: false, with_timestamp: true },
          ["my_line", { to_output: false, to_interactive: true, as_of: "NOW" }],
          { output_buffer: [], interactive_buffer: ["=>\tmy_line"] }
        ],[
          { defer_output: false },
          ["my_line", { to_output: true, to_interactive: false, as_of: "NOW" }],
          { output_buffer: ["my_line"], interactive_buffer: [] }
        ],[
          { defer_output: false },
          ["my_line", { to_output: false, to_interactive: false, as_of: "NOW" }],
          { output_buffer: [], interactive_buffer: [] }
        ]
      ].each do |initialize_with, args, expected|
        describe "initialized_with: #{initialize_with.inspect}" do
          let(:renderer) do
            described_class.new(
              interactive_buffer: interactive_buffer,
              output_buffer: output_buffer,
              **initialize_with
            )
          end
          describe "#call(#{args.inspect})" do
            subject { renderer.call(*args) }
            it "handles output and interactive buffer (#{expected.inspect})" do
              expected.each_pair do |key, expected_to_receive|
                expected_to_receive.each do |expected|
                  expect(public_send(key)).to receive(:puts).with(expected)
                end
              end
              subject
            end
          end
        end
      end
    end
  end
end
