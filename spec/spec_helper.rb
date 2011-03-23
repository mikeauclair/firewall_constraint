require "bundler"
Bundler.setup
ENV["RAILS_ENV"] ||= 'test'
require 'rails_app/config/environment'
require 'rspec/rails'
require 'shoulda/integrations/rspec2'
require 'rubygems'

RSpec.configure do |config|
  config.before(:all) do
    
  end

end