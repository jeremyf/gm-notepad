require "spec_helper"

RSpec.describe Gm::Notepad do
  it "has a version number" do
    expect(Gm::Notepad::VERSION).not_to be nil
  end
end
