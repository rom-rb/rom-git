# coding: utf-8

require File.expand_path('../lib/rom/git/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "rom-git"
  spec.version       = ROM::Git::VERSION
  spec.authors       = ["Franck Verrot", "Piotr Solnica"]
  spec.email         = ["franck@verrot.fr", "piotr.solnica+oss@gmail.com"]
  spec.summary       = "Git adapter for the rom-rb"
  spec.description   = spec.summary
  spec.homepage      = "http://rom-rb.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})

  spec.add_runtime_dependency "rom", "~> 2.0"
  spec.add_runtime_dependency "rugged", "~> 0.24"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
