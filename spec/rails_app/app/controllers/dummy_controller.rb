class DummyController < ApplicationController
  def index
    render :text => "index"
  end
  
  def blocked_by_inline
    render :text => "inline"
  end
  
  def blocked_by_block    
    render :text => "block"
  end
  
  def blocked_by_dynamic
    render :text => "dynamic"
  end
end