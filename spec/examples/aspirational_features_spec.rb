require 'spec_helper'
require 'gm/notepad'

RSpec.describe "An aspirational feature" do
  let(:output_buffer) { SpecSupport::Buffer.new("output") }
  let(:path_to_fixtures) { PATH_TO_FIXTURES }
  let(:interactive_buffer) { SpecSupport::Buffer.new("interactive") }
  let(:notepad) do
    Gm::Notepad.new(
      with_timestamp: false,
      report_config: false,
      output_buffer: output_buffer,
      interactive_buffer: interactive_buffer,
      defer_output: false,
      paths: [path_to_fixtures]
    )
  end

  xit "allows specifying that the line be written to the output buffer when normally it would only be written to the interactive buffer" do
    # Assumption is that the leading character ">" tells the
    # renderer to write the evaluated input to the output buffer
    [
      ">?",
    ].each do |input|
      notepad.process(input: input)
    end
    notepad.close!
    expect(output_buffer.lines[0]).not_to eq(">?")
    expect(output_buffer.lines.count).to eq(interactive_buffer.lines.count)
  end
end
