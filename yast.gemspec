# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yast/version"

Gem::Specification.new do |s|
  s.name        = "yast"
  s.version     = Yast::VERSION
  s.authors     = ["Thomas Smestad"]
  s.email       = ["smestad.thomas@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{API to http://www-yast.com}
  s.description = %q{Gem to use Yast API}

  s.rubyforge_project = "yast"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.test_files    = Dir.glob("spec/**/*.rb")

  s.add_dependency('builder')
  s.add_dependency('xml-simple')

  s.add_development_dependency 'rspec', '~> 2.6'
end
