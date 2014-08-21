source ENV['FLO_GEM_SERVER'] 


## RA Gems
#gem 'ra-client', '2.0.161'
gem 'ra-client', :path=>'../ra-client'
#gem 'ra-core', '2.0.30', :require => ['ra-core/rasl_logger', 'ra-core']
gem 'ra-core', :path=>'../ra-core', :require => ['ra-core/rasl_logger', 'ra-core']

#kafka gem
gem 'poseidon', :git => 'https://github.com/bpot/poseidon.git'


## Component Gems
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'activerecord', '3.1.3.patched', :require => 'active_record'
gem 'activerecord-import', '>= 0.2.0'
gem 'activerecord_use_slave', '0.0.5'
gem 'actionpack'
gem 'json'
gem 'mysql2'
gem 'padrino', '0.10.5.patched'
gem 'rake'
gem 'rack', '1.3.6'
gem 'rack-metrics', '1.0.5'
gem 'rest-client', :require => 'restclient'
gem 'state_machine'
gem 'uuidtools'
gem 'unicorn', '4.6.3'
gem 'unicorn-worker-killer'

## Supply Chain Gems
gem 'sc-cache'
gem 'sc-rest-client','1.1.0'
gem 'sc-core', '1.1.32', :require => ['sc_core/base_application', 'sc_core/message_bus', 'sc_core/add_timestamp_migrations_to_padrino']
gem 'sc-metrics', '1.0.5', :require => 'sc_metrics'
gem 'sc-mq','1.0.8', :require => 'sc_mq'
gem 'sc-auth', '1.1.2'
gem 'sc-user-data', '1.0.0'
gem 'sc-customer','0.0.67'
gem 'couchbase', '1.3.3'
gem 'rubycas-client', '2.3.9.7.patched'
# Test requirements
group :test, :ci do
  #gem 'metric_fu'
  gem 'rack-test', :require => 'rack/test'
  gem 'ci_reporter', :require => false
  gem 'rspec'
  gem 'database_cleaner'
  gem 'pry'
  gem 'simplecov-rcov', :require=>false, :platform => 'ruby'
  #gem 'rcov', '0.9.11'
  gem 'factory_girl', '~> 4.0'
end

group :development do
  gem 'passenger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
end
