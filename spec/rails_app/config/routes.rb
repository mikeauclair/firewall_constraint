RailsApp::Application.routes.draw do
  get 'dummy/index' => 'dummy#index'
  get 'dummy/blocked_by_inline' => 'dummy#blocked_by_inline', :constraints => FirewallConstraint::Constraint.new
  
  constraints FirewallConstraint::Constraint.new do
    get 'dummy/blocked_by_block' => 'dummy#blocked_by_block'
  end
  
  root :to => 'dummy#index'
end
