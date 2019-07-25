require 'spec_helper'
require 'gmshell'
class Buffer
  attr_reader :name, :lines
  def initialize(name)
    @name = name
    @lines = []
  end
  def puts(line)
    @lines << line
  end
end
RSpec.describe "basic features" do
  let(:output_buffer) { Buffer.new("output") }
  let(:path_to_fixtures) { File.expand_path('../../fixtures', __FILE__) }
  let(:interactive_buffer) { Buffer.new("interactive") }
  let(:notepad) do
    Gmshell::Notepad.new(
      with_timestamp: false,
      skip_config_reporting: true,
      output_buffer: output_buffer,
      interactive_buffer: interactive_buffer,
      defer_output: false,
      paths: [path_to_fixtures]
    )
  end

  it "scenario 1" do
    [
      "?",
      "+",
      "+na",
      "+name",
      %(Hello "{name}" nice to meet you and "{name}"),
      "{unregistered}",
      "[2d6]"
    ].each do |input|
      notepad.process(input: input)
    end
    notepad.close!
    expect(output_buffer.lines.count).to eq(3)
  end
  it "scenario 2" do
    [
      "+name[1]",
      "+first-name/ipp/",
      "+na"
    ].each do |input|
      notepad.process(input: input)
    end
    notepad.close!
    expect(output_buffer.lines).to eq([])
    expect(interactive_buffer.lines).to eq(
      [
        "=>\t{first-name} {last-name}",
        "=>\tPippin",
        "=>\tUnknown table \"na\". Did you mean: \"name\""
      ]
    )
  end
end