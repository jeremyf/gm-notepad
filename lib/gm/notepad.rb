require "gm/notepad/version"
require "gm/notepad/defaults"
require "gm/notepad/pad"
module Gm
  module Notepad
    def self.new(*args)
      Pad.new(*args)
    end
  end
end
