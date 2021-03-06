# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fs/version"

Gem::Specification.new do |s|
  s.name        = "fs"
  s.version     = FS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bernd Jünger"]
  s.email       = ["blindgaenger@gmail.com"]
  s.homepage    = "http://github.com/blindgaenger/fs"
  s.summary     = %q{Work with your filesystem!}
  s.description = %q{FS gathers the cluttered methods for working with files and dirs. Internally using the good old standard library, but providing simple methods in a single place.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end