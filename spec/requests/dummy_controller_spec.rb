require 'spec_helper'

describe "DummyController", type: :request do
  it 'should get default action' do
    get '/dummy/index'
    expect(response).to be_success
  end
  
  it 'should get dynamic constraint' do
    get root_path
    open_session do |sess|
      sess.remote_addr = '127.0.0.1'
      get '/dummy/blocked_by_dynamic'
      expect(response).to be_success
    end
  end
  
  it 'should get procced constraint' do
    get root_path
    open_session do |sess|
      sess.remote_addr = '127.0.0.1'
      get '/dummy/blocked_by_proc'
      expect(response).to be_success
    end
  end

  it 'should get ipv6 constraint' do
    ipv6 = 'fe80::d69a:20ff:fe0d:45fe'
    get root_path
    open_session do |sess|
      sess.remote_addr = ipv6
      get '/dummy/blocked_by_ipv6'
      expect(response).to be_success

    end
  end
  
  context 'given a bad ipv6 ip' do
    around do |example|
      ipv6 = 'fe80::d69a:20ff:fe0d:45ff'
      get root_path
      open_session do |sess|
        sess.remote_addr = ipv6
        example.run
      end
    end
    
    it 'should not vomit on an ipv4 rule' do
      expect { get '/dummy/blocked_by_block' }.to raise_error ActionController::RoutingError
    end
    
    it 'should block on an ipv6 rule' do
      expect { get '/dummy/blocked_by_ipv6'}.to raise_error ActionController::RoutingError
    end
  end
  
  it 'should not vomit given a bad ipv6 ip' do
    ipv6 = 'fe80::d69a:20ff:fe0d:45fe'
    get root_path
    open_session do |sess|
      sess.remote_addr = ipv6
      expect {get '/dummy/blocked_by_block'}.to raise_error ActionController::RoutingError
    end
  end

  it 'should not vomit given a list of IPs in HTTP_X_FORWARDED_FOR -- and should look at the leftmost IP in the list' do
    ip_list = '1.2.3.4, 10.0.0.1'
    get root_path
    open_session do |sess|
      sess.remote_addr = ip_list
      expect {get '/dummy/blocked_by_block', nil, {"HTTP_X_FORWARDED_FOR" => ip_list}}.to raise_error ActionController::RoutingError
    end
  end

  
  context 'given a good ip' do
    around do |example|
      get root_path
      open_session do |sess|
        sess.remote_addr = '10.0.0.45'
        example.run
      end
    end
    
    it 'should get inline constraint' do
      get '/dummy/blocked_by_inline'
      expect(response).to be_success
    end
    
    it 'should get block constraint' do
      get '/dummy/blocked_by_block'
      expect(response).to be_success
    end
  end
  
  context 'given a bad ip' do
    around do |example|
      get root_path
      open_session do |sess|
        sess.remote_addr = '55.55.55.55'
        example.run
      end
    end
    
    it 'should not vomit on an ipv4 rule' do
      expect {get '/dummy/blocked_by_ipv6'}.to raise_error ActionController::RoutingError
      
    end
    
    it 'should not get inline constraint' do
      expect {get '/dummy/blocked_by_inline'}.to raise_error ActionController::RoutingError
    end

    it 'should not get procced constraint' do
      expect {get '/dummy/blocked_by_proc'}.to raise_error ActionController::RoutingError
    end
    
    it 'should not get block constraint' do
      expect{get '/dummy/blocked_by_block'}.to raise_error ActionController::RoutingError
    end
    
    it 'should not get dynamic constraint' do
      expect{get '/dummy/blocked_by_dynamic'}.to raise_error ActionController::RoutingError
    end

    context 'given a provided exception' do
      around do |example|
        FirewallConstraint.config do |fc|
          fc.raise_exception = ActionController::BadRequest
        end
        example.run
        FirewallConstraint.config.raise_exception = nil
      end

      it 'should throw the correct exception' do
        expect{get '/dummy/blocked_by_dynamic'}.to raise_error ActionController::BadRequest
      end
    end
  end
end
