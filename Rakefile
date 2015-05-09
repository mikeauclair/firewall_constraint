require 'bundler'
begin
  require 'rspec/core/rake_task'
rescue LoadError
end

Bundler::GemHelper.install_tasks

desc 'Default: Run specs'
task :default => :spec

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |spec|
  # spec.libs << 'lib' << 'spec'
  # spec.spec_files = FileList['spec/**/*_spec.rb']
  # spec.rcov = true
  # spec.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/}
end

task :cleanup_rcov_files do
  rm_rf 'coverage'
end

desc "Run all examples using rcov"
RSpec::Core::RakeTask.new :rcov => :cleanup_rcov_files do |t|
  t.rcov = true
  t.rcov_opts =  %[-Ilib -Ispec --exclude "gems/*,features"]
  t.rcov_opts << %[--text-report --sort coverage --html]
end

# desc  "Run all specs with rcov"
# RSpec::Core::RakeTask.new(:rcov => spec_prereq) do |t|
#   
# end
