require 'spec_helper'
require 'gm/notepad/line_renderer'

module Gm
  module Notepad
    RSpec.describe LineRenderer do
      let(:interactive_buffer) { SpecSupport::Buffer.new("Interactive Buffer") }
      let(:output_buffer) { SpecSupport::Buffer.new("Output Buffer") }
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
        ],[
          { defer_output: false, interactive_color: true, output_color: true },
          ["my_line", { to_output: true, to_interactive: true, as_of: "NOW" }],
          { output_buffer: ["\e[1mmy_line\e[0m"], interactive_buffer: ["\e[2m=>\tmy_line\e[0m"] }
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
              subject
              expected.each_pair do |key, expected_to_receive|
                expect(public_send(key).lines).to eq(expected_to_receive)
              end
            end
          end
        end
      end
    end
  end
end
