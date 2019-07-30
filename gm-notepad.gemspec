# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gm/notepad/version"

Gem::Specification.new do |spec|
  spec.name          = "gm-notepad"
  spec.version       = Gm::Notepad::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]

  spec.summary       = %q{A command line tool for GM-ing}
  spec.description   = %q{A command line tool for GM-ing}
  spec.homepage      = "https://github.com/jeremyf/gm-notepad"
  spec.license       = "APACHE2"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dice_parser"
  spec.add_dependency "dry-configurable"
  spec.add_dependency "dry-container"
  spec.add_dependency "dry-initializer"
  spec.add_dependency "term-ansicolor"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "simplecov"
end
