RailsApp::Application.routes.draw do
  get 'dummy/index' => 'dummy#index'
  get 'dummy/blocked_by_inline' => 'dummy#blocked_by_inline', :constraints => FirewallConstraint.new
  
  constraints FirewallConstraint.new do
    get 'dummy/blocked_by_block' => 'dummy#blocked_by_block'
  end
  
  constraints FirewallConstraint.new(['127.0.0.1']) do
    get 'dummy/blocked_by_dynamic' => 'dummy#blocked_by_dynamic'
  end
  
  constraints FirewallConstraint.new([]) do
    root :to => 'dummy#index'
  end
  
  constraints FirewallConstraint.new('fe80::d69a:20ff:fe0d:45fe') do
    get 'dummy/blocked_by_ipv6'
  end

  constraints FirewallConstraint.new(Proc.new{['127.0.0.1']}) do
    get 'dummy/blocked_by_proc'
  end
end
