require "bundler/gem_tasks"
require "rspec/core/rake_task"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/**/*_spec.rb"
  ENV['COVERAGE'] = 'true'
end

namespace :commitment do
  task :configure_test_for_code_coverage do
    ENV['COVERAGE'] = 'true'
  end
  task :code_coverage do
    require 'json'
    $stdout.puts "Checking code_coverage"
    lastrun_filename = File.expand_path('../coverage/.last_run.json', __FILE__)
    if File.exist?(lastrun_filename)
      coverage_percentage = JSON.parse(File.read(lastrun_filename)).fetch('result').fetch('covered_percent').to_i
      EXPECTED_COVERAGE_GOAL = 99
      if coverage_percentage < EXPECTED_COVERAGE_GOAL
        abort("ERROR: Code Coverage Goal Not Met:\n\t#{coverage_percentage}%\tExpected\n\t#{EXPECTED_COVERAGE_GOAL}%\tActual")
      else
        $stdout.puts "Code Coverage Goal Met (at least #{EXPECTED_COVERAGE_GOAL}% coverage)"
      end
    else
      abort "Expected #{lastrun_filename} to exist for code coverage"
    end
  end
end

task(default: ['commitment:configure_test_for_code_coverage', :spec, 'commitment:code_coverage'])
task(build: :default)
task(release: :default)
