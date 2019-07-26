require "bundler/setup"
GEM_ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift File.join(GEM_ROOT, 'lib')
require "gm/notepad"
require 'rspec/its'

PATH_TO_FIXTURES = File.expand_path('../fixtures', __FILE__)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# For testing purposes you may want a buffer that conforms to the
# expected interface.
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
