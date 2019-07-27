require 'rspec/expectations'

RSpec::Matchers.define :handle do |expected|
  match do |actual|
    actual.handles?(input: expected)
  end
end
