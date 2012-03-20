FirewallConstraint
========

Easy whitelist firewalling for Rails 3 route constraints

    gem 'firewall_constraint'

Or:

    gem install firewall_constraint

-----

config/routes.rb:

    get 'dummy/index' => 'dummy#index'
    get 'dummy/blocked_by_inline' => 'dummy#blocked_by_inline', :constraints => FirewallConstraint::Constraint.new
  
    constraints FirewallConstraint::Constraint.new do
      get 'dummy/blocked_by_block' => 'dummy#blocked_by_block'
    end
  
    constraints FirewallConstraint::Constraint.new(['127.0.0.1']) do
      get 'dummy/blocked_by_dynamic' => 'dummy#blocked_by_dynamic'
    end

    constraints FirewallConstraint::Constraint.new(Proc.new{['127.0.0.1']}) do
      get 'dummy/blocked_by_proc'
    end

----

Uses a config file if ips not present in routes

config/firewall_constraint.yml:

    test:
      - 10.0.0.0/8

----

You should be able to do DB-based whitelisting using the Proc whitelisting and an activerecord lookup or something similar to:

    constraints FirewallConstraint::Constraint.new(Proc.new{ValidIps.all.map{|x| x.ip}})