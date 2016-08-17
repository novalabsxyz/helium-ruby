require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

namespace :doc do
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |task|
      task.options = [
        '--output-dir', 'doc',
        '--markup', 'markdown',
      ]
    end
  rescue LoadError
  end
end
