# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "rom-git"
  spec.version       = "1.0.0"
  spec.authors       = ["Franck Verrot"]
  spec.email         = ["franck@verrot.fr"]
  spec.summary       = "Git support for the ROM Ruby Object Mapper"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/franckverrot/rom-git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})

  spec.add_runtime_dependency "rom", "~> 0.5", ">= 0.5.0"

  spec.add_dependency "rugged"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "anima"
end
