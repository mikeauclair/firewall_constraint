require "bundler"
Bundler.setup
ENV["RAILS_ENV"] ||= 'test'
require 'rails_app/config/environment'
require 'rspec/rails'
require 'rubygems'

RSpec.configure do |config|
  config.before(:all) do
    class ::ApplicationController < ActionController::Base
    end
  end

end