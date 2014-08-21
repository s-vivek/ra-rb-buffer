require File.expand_path('../config/boot.rb', __FILE__)
require 'ci/reporter/rake/test_unit'
require 'padrino-core/cli/rake'

desc 'This is a ci_test task for running all ci_tests'
task :ci_test => %w(ci:setup:testunit spec)


PadrinoTasks.init
