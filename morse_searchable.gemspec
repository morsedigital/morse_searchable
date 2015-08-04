$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "morse_searchable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "morse_searchable"
  s.version     = MorseSearchable::VERSION
  s.authors     = ["fredmcgroarty"]
  s.email       = ["mcfremac@icloud.com"]
  s.summary     = "A simple API to provide a searchable feed of associated data"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "jbuilder", "~> 2.0"
  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'pry-rails'

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency "spring"
  s.add_development_dependency "spring-commands-rspec"
end
