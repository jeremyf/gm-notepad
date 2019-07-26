require "gm/notepad/version"
require "gm/notepad/pad"
module Gm
  module Notepad
    # Your code goes here...
    def self.new(*args)
      Pad.new(*args)
    end
  end
end
