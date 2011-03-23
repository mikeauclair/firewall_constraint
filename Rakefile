require 'bundler'
require 'rspec'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

desc 'Default: Run specs'
task :default => :spec

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |spec|
  # spec.libs << 'lib' << 'spec'
  # spec.spec_files = FileList['spec/**/*_spec.rb']
end