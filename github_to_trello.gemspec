# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_to_trello/version'

Gem::Specification.new do |spec|
  spec.name          = "github_to_trello"
  spec.version       = GithubToTrello::VERSION
  spec.authors       = ["chrissie"]
  spec.email         = ["chrissie.deist@gmail.com"]
  spec.description   = %q{A gem for converting github issues into trello cards}
  spec.summary       = %q{Pulls github issues from specified repos and automatically creates/populates trello lists with the repo names on a specified board.}
  spec.homepage      = "https://github.com/chrissiedeist/github_to_trello"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "octokit", "~> 4.0.1"
  spec.add_dependency "ruby-trello", "~> 1.2.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency "rake"
end
