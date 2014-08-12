# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fs/version'

Gem::Specification.new do |spec|
  spec.name          = 'fs'
  spec.version       = FS::VERSION
  spec.authors       = ['Bernd Jünger']
  spec.email         = ['blindgaenger@gmail.com']
  spec.homepage      = 'http://github.com/blindgaenger/fs'
  spec.summary       = %q{Work with your filesystem!}
  spec.description   = %q{FS gathers the cluttered methods for working with files and dirs. Internally using the good old standard library, but providing simple methods in a single place.}
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
