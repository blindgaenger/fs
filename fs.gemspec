# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fs/version"

Gem::Specification.new do |s|
  s.name        = "fs"
  s.version     = FS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bernd Jünger"]
  s.email       = ["blindgaenger@gmail.com"]
  s.homepage    = "http://blindgaenger.net"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.add_development_dependency 'rspec', '2.5.0'
  s.add_development_dependency 'fakefs', '0.3.1'
  s.add_development_dependency 'ruby-debug19', '0.11.6'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
