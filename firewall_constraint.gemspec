# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "firewall_constraint/version"

Gem::Specification.new do |s|
  s.name        = "firewall_constraint"
  s.version     = FirewallConstraint::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Auclair"]
  s.email       = ["mike@mikeauclair.com"]
  s.homepage    = "http://github.com/mikeauclair/firewall_constraint"
  s.summary     = %q{Rails 3 firewall route constraints}
  s.description = %q{Rails 3 firewall route constraints}

  s.rubyforge_project = "firewallconstraint"
  
  s.add_development_dependency(%q<rails>, ["3.0.5"])
  s.add_dependency(%q<rails>, ["~> 3.0.0"])
  s.add_dependency(%q<ipaddress>)
	s.add_development_dependency(%q<shoulda>)
  s.add_development_dependency(%q<rspec-rails>, ["~> 2.5.0"])
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
