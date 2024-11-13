
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bambooing/version"

Gem::Specification.new do |spec|
  spec.name          = "bambooing"
  spec.version       = Bambooing::VERSION
  spec.authors       = ["Jose Lloret"]
  spec.email         = ["jollopre@gmail.com"]

  spec.summary       = %q{A gem to track bamboo time}
  spec.description   = %q{.}
  spec.homepage      = "https://github.com/jollopre"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = ""
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jollopre"
  spec.metadata["changelog_uri"] = "https://github.com/jollopre"

  spec.files = Dir["lib/**/*.rb"] + Dir["bin/*"] + Dir["CODE_OF_CONDUCT.md", "bambooing.gemspec", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]
end
