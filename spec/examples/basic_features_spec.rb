require 'spec_helper'
require 'gm/notepad'
require 'gm/notepad/app'

RSpec.describe "basic features" do
  before do
    Gm::Notepad::Config.config.paths = [PATH_TO_FIXTURES]
    Gm::Notepad::Config.config.output_buffer = output_buffer
    Gm::Notepad::Config.config.interactive_buffer = interactive_buffer
    Gm::Notepad::Config.config.interactive_color = false
    Gm::Notepad::Config.config.output_color = false
  end

  let(:output_buffer) { SpecSupport::Buffer.new("output") }
  let(:path_to_fixtures) { PATH_TO_FIXTURES }
  let(:interactive_buffer) { SpecSupport::Buffer.new("interactive") }
  let(:notepad) do
    Gm::Notepad.new(
      output_buffer: output_buffer,
      interactive_buffer: interactive_buffer,
      interactive_color: false,
      paths: [path_to_fixtures]
    )
  end

  it "scenario 1: expected commands" do
    [
      "?",
      "+",
      "+na",
      "+name",
      "+name[]",
      %(Hello "{name}" nice to meet you and "{name}"),
      "{unregistered}",
      "[2d6]"
    ].each do |text|
      notepad.process(text: text)
    end
    notepad.close!
    expect(output_buffer.lines.count).to eq(3)
  end
  it "scenario 2: testing specific output" do
    [
      "+name[1]",
      "+first-name/ipp/",
      "+na"
    ].each do |text|
      notepad.process(text: text)
    end
    notepad.close!
    expect(output_buffer.lines).to eq([])
    # Becase the last three lines should be the above table's evaluated
    expect(interactive_buffer.lines[-3..-1]).to eq(
      [
        "=>\t[1]\t{first-name} {last-name}",
        "=>\t[3]\tPippin",
        "=>\tUnknown table \"na\". Did you mean: \"name\""
      ]
    )
  end
  it "scenario 3: verifying help does not write to output" do
    [
      "?"
    ].each do |text|
      notepad.process(text: text)
    end
    notepad.close!
    expect(output_buffer.lines.count).to eq(0)
  end
  it "scenario 4: verifying expansion works" do
    [
      %(Hello "{name}" nice to meet you and "{name}")
    ].each do |text|
      notepad.process(text: text)
    end
    notepad.close!
    expect(output_buffer.lines.count).to eq(1)
    expect(output_buffer.lines[0]).not_to match(/\{/)
  end
  it "scenario 5: demonstrating non-expansion" do
    [
      %(!{name})
    ].each do |text|
      notepad.process(text: text)
    end
    notepad.close!
    expect(output_buffer.lines).to eq(["{name}"])
  end
end
