lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "minitest/mock_expectations/version"

Gem::Specification.new do |spec|
  spec.name          = "minitest-mock_expectations"
  spec.version       = Minitest::MockExpectations::VERSION
  spec.authors       = ["bogdanvlviv"]
  spec.email         = ["bogdanvlviv@gmail.com"]

  spec.summary       = "Provides method call assertions"
  spec.description   = ""
  spec.homepage      = "https://github.com/bogdanvlviv/minitest-mock_expectations"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
