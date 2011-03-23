RailsApp::Application.routes.draw do
  get 'dummy/index' => 'dummy#index'
  get 'dummy/blocked_by_inline' => 'dummy#blocked_by_inline', :constraints => FirewallConstraint::Constraint.new
  
  constraints FirewallConstraint::Constraint.new do
    get 'dummy/blocked_by_block' => 'dummy#blocked_by_block'
  end
  
  constraints FirewallConstraint::Constraint.new(['127.0.0.1']) do
    get 'dummy/blocked_by_dynamic' => 'dummy#blocked_by_dynamic'
  end
  
  root :to => 'dummy#index'
  
  constraints FirewallConstraint::Constraint.new('fe80::d69a:20ff:fe0d:45fe') do
    get 'dummy/blocked_by_ipv6'
  end
end
