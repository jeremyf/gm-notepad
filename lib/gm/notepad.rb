require "gm/notepad/version"
require "gm/notepad/defaults"
require "gm/notepad/pad"
require "gm/notepad/configuration"
module Gm
  module Notepad
    def self.new(*args)
      config = Configuration.new(*args)
      Pad.new(config: config)
    end
  end
end
