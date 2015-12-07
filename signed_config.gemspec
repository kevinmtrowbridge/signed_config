$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "signed_config"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "signed_config"
  s.version     = SignedConfig::VERSION
  s.authors = ["Kevin Trowbridge"]
  s.email = ["kevinmtrowbridge@gmail.com"]
  s.homepage = "http://www.kevinmtrowbridge.com"
  s.summary = "Cryptograpically sign a configuration hash.  A way to enforce configuration / licensing of an installed Ruby application."
  s.license = "MIT"

  s.files = Dir["lib/**/*", "README.md"]
  s.test_files = Dir["test/**/*"]
end
