$:.push File.expand_path("../lib", __FILE__)
require "callcounter/version"

Gem::Specification.new do |spec|
  spec.name = "callcounter"
  spec.version = Callcounter::VERSION
  spec.authors = ["George Buckley"]
  spec.email = ["george@lint.com"]
  spec.homepage = "https://github.com/Callcounter/callcounter-ruby"
  spec.summary = "Callcounter integration gem to gather API request statistics"
  spec.description = "Callcounter is a service that helps API providers with debugging and optimising the usage of their APIs."

  spec.files = Dir["{lib}/**/*", "LICENSE", "README.md"]
  spec.test_files = []

  spec.require_paths = ["lib"]
end