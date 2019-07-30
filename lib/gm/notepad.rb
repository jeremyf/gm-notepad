require "gm/notepad/version"
require 'gm/notepad/config'
require "gm/notepad/app"
module Gm
  module Notepad
    def self.new(finalize: false, **config_parameters)
      config_parameters.each_pair do |key, value|
        Config.config.public_send("#{key}=", value)
      end
      Config.finalize! if finalize
      App.new
    end
  end
end
