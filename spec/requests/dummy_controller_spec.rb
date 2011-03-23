require 'spec_helper'

describe "dummy stuff" do
  before(:all) do

  end
  it 'should get default action' do
    get '/dummy/index'
    response.should be_success
  end
  
  it 'should get dynamic constraint' do
    get root_path, nil, "REMOTE_ADDR" => "127.0.0.1"
    open_session do |sess|
      sess.remote_addr = '127.0.0.1'
      get '/dummy/blocked_by_dynamic'
      response.should be_success
    end
  end
  
  it 'should get ipv6 constraint' do
    ipv6 = 'fe80::d69a:20ff:fe0d:45fe'
    get root_path, nil, "REMOTE_ADDR" => ipv6
    open_session do |sess|
      sess.remote_addr = ipv6
      get '/dummy/blocked_by_ipv6'
      response.should be_success
    end
  end
  
  context 'given a bad ipv6 ip' do
    around do |example|
      ipv6 = 'fe80::d69a:20ff:fe0d:45ff'
      get root_path, nil, "REMOTE_ADDR" => ipv6
      open_session do |sess|
        sess.remote_addr = ipv6
        example.run
      end
    end
    
    it 'should not vomit on an ipv4 rule' do
      get '/dummy/blocked_by_block'
      response.status.should eql 404
    end
    
    it 'should block on an ipv6 rule' do
      get '/dummy/blocked_by_ipv6'
      response.status.should eql 404
    end
  end
  
  it 'should not vomit given a bad ipv6 ip' do
    ipv6 = 'fe80::d69a:20ff:fe0d:45fe'
    get root_path, nil, "REMOTE_ADDR" => ipv6
    open_session do |sess|
      sess.remote_addr = ipv6
      get '/dummy/blocked_by_block'
      response.status.should eql 404
    end
  end
  
  context 'given a good ip' do
    around do |example|
      get root_path, nil, "REMOTE_ADDR" => "10.0.0.45"
      open_session do |sess|
        sess.remote_addr = '10.0.0.45'
        example.run
      end
    end
    
    it 'should get inline constraint' do
        get '/dummy/blocked_by_inline'
        response.should be_success
    end
    
    it 'should get block constraint' do
      get '/dummy/blocked_by_block'
      response.should be_success
    end
  end
  
  context 'given a bad ip' do
    around do |example|
      get root_path, nil, "REMOTE_ADDR" => "55.55.55.55"
      open_session do |sess|
        sess.remote_addr = '55.55.55.55'
        example.run
      end
    end
    
    it 'should not vomit on an ipv4 rule' do
      get '/dummy/blocked_by_ipv6'
      response.status.should eql 404
    end
    
    it 'should not get inline constraint' do
      get '/dummy/blocked_by_inline'
      response.status.should eql 404
    end
    
    it 'should not get block constraint' do
      get '/dummy/blocked_by_block'
      response.status.should eql 404 
    end
    
    it 'should not get dynamic constraint' do
      get '/dummy/blocked_by_dynamic'
      response.status.should eql 404 
    end
  end
end