require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => "spec:unit"
task "spec:all" => %w[spec:unit spec:integration]

desc "Run unit tests"
RSpec::Core::RakeTask.new("spec:unit") do |t|
  t.pattern = "spec/unit/*.rb"
end

desc "Run integration tests"
RSpec::Core::RakeTask.new("spec:integration") do |t|
  t.pattern = "spec/integration/*.rb"
end
