require 'spec_helper'
require 'gm/notepad'

RSpec.describe "with default configuration" do
  before do
    Gm::Notepad::Config.config.paths = [PATH_TO_FIXTURES]
    Gm::Notepad::Config.config.output_buffer = output_buffer
    Gm::Notepad::Config.config.interactive_buffer = interactive_buffer
    Gm::Notepad::Config.config.interactive_color = false
    Gm::Notepad::Config.config.output_color = false
  end
  let(:output_buffer) { SpecSupport::Buffer.new("output") }
  let(:interactive_buffer) { SpecSupport::Buffer.new("output") }
  # TODO: Add test for filesystem and if the results were evaluated
  RSpec::Matchers.define "meet_processing_expectations" do |interactive:, output:|
    match do |text|
      notepad = Gm::Notepad.new(
        output_buffer: output_buffer,
        interactive_buffer: interactive_buffer,
        paths: [PATH_TO_FIXTURES]
      )
      notepad.process(text: text)
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
