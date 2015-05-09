# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "firewall_constraint/version"

Gem::Specification.new do |s|
  s.name        = "firewall_constraint"
  s.version     = FirewallConstraint::VERSION
  s.licenses    = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Auclair"]
  s.email       = ["mike@mikeauclair.com"]
  s.homepage    = "http://github.com/mikeauclair/firewall_constraint"
  s.summary     = %q{Rails 3+4 firewall route constraints}
  s.description = %q{Rails 3+4 firewall route constraints for keeping the bad guys out.}

  s.rubyforge_project = "firewallconstraint"
  
  s.add_dependency(%q<rails>, ["> 3.0.0", "< 5.0.0"])
  s.add_dependency(%q<ipaddress>, ['~> 0.8'])
  s.add_development_dependency(%q<rake>, ['~> 0'])
  s.add_development_dependency(%q<rspec-rails>, ["~> 3.2"])
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
