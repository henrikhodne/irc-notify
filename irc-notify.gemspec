# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "irc-notify/version"

Gem::Specification.new do |spec|
  spec.name = "irc-notify"
  spec.version = IrcNotify::VERSION
  spec.authors = ["Henrik Hodne"]
  spec.email = ["henrik@hodne.io"]
  spec.description = "irc-notify is a minimal library for publishing IRC notifications"
  spec.summary = "irc-notify is a minimal library for publishing IRC notifications"
  spec.homepage = "https://github.com/henrikhodne/irc-notify"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-rspec"
end
