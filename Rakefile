require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => "spec:integration"

desc "Run tests"
RSpec::Core::RakeTask.new("spec:integration") do |t|
    t.pattern = "spec/*.rb"
end
