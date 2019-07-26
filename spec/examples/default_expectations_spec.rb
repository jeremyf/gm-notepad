require 'spec_helper'
require 'gm/notepad'

RSpec.describe "with default configuration" do
  # TODO: Add test for filesystem and if the results were evaluated
  RSpec::Matchers.define "meet_processing_expectations" do |interactive:, output:|
    match do |input|
      output_buffer = SpecSupport::Buffer.new("output")
      interactive_buffer = SpecSupport::Buffer.new("interactive")
      notepad = Gm::Notepad.new(
        output_buffer: output_buffer,
        interactive_buffer: interactive_buffer,
        paths: [PATH_TO_FIXTURES]
      )
      notepad.process(input: input)
      (output_buffer.lines.count > 0) == output &&
      (interactive_buffer.lines.count > 0) == interactive
    end
  end
  describe "?" do
    it { is_expected.to meet_processing_expectations(interactive: true, output: false) }
  end
  describe "+" do
    it { is_expected.to meet_processing_expectations(interactive: true, output: false) }
  end
  describe "+name" do
    it { is_expected.to meet_processing_expectations(interactive: true, output: false) }
  end
  describe "+na" do
    it { is_expected.to meet_processing_expectations(interactive: true, output: false) }
  end
  describe "{name}" do
    it { is_expected.to meet_processing_expectations(interactive: true, output: true) }
  end
end
