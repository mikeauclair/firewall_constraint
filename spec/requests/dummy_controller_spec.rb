require 'spec_helper'

describe "dummy stuff" do
  before(:all) do

  end
  it 'should get default action' do
    get '/dummy/index'
    response.should be_success
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
    
    it 'should not get inline constraint' do
      get '/dummy/blocked_by_inline'
      response.status.should eql 404
    end
    
    it 'should not get block constraint' do
      get '/dummy/blocked_by_block'
      response.status.should eql 404 
    end
  end
end