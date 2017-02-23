# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'limpo/repository/version'

Gem::Specification.new do |spec|
  spec.name          = "limpo-repository"
  spec.version       = Limpo::Repository::VERSION
  spec.authors       = ["Thiago Rodrigues de Paula"]
  spec.email         = ["thiago.rdp@gmail.com"]

  spec.summary       = %q{An approach to implement a non-opinionated repository toolset using good object oriented principles.}
  spec.description   = %q{An approach to implement a non-opinionated repository toolset using good object oriented principles.}
  spec.homepage      = "https://github.com/thiagorp/limpo-repository"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
