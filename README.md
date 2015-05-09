FirewallConstraint
========

Easy whitelist firewalling for Rails 3+4 route constraints

    gem 'firewall_constraint'

Or:

    gem install firewall_constraint

-----
##Example

config/routes.rb:

    get 'dummy/index' => 'dummy#index'
    get 'dummy/blocked_by_inline' => 'dummy#blocked_by_inline', :constraints => FirewallConstraint.new

    constraints FirewallConstraint.new do
      get 'dummy/blocked_by_block' => 'dummy#blocked_by_block'
    end

    constraints FirewallConstraint.new(['127.0.0.1']) do
      get 'dummy/blocked_by_dynamic' => 'dummy#blocked_by_dynamic'
    end

    constraints FirewallConstraint.new(Proc.new{['127.0.0.1']}) do
      get 'dummy/blocked_by_proc'
    end

----
##Configuration

Uses a config file if ips are not provided on instantiation

config/firewall_constraint.yml:

    test:
      - 10.0.0.0/8

----
##Advanced Usage

You can also do DB-based whitelisting using the Proc-based whitelisting method:

app/models/valid_ip.rb:

    class ValidIp < ActiveRecord::Base
    end

config/routes.rb:

    constraints FirewallConstraint.new(Proc.new{ValidIp.pluck(:ip)}) do
      get '/blah'
    end

----
##Notes

Because parsing IPs with the IPAddress can take some time, this gem will only reparse ips returned by the Proc method if they have changed.  Make sure you return your ips in the same order to avoid unnecessary reparsing.
