# Defines our constants
SERVICE_NAME = "ra-rb-buffer"
DEPLOY_ENV = ENV['DEPLOY_ENV'] || "localhost"
ENV['LOG_REQ_RESP_CLIENT']='Y'

PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Initialize logging here, otherwise it doesn't take effect for non-standard environments
# (i.e. other than dev, test, prod) when running through trinidad
PADRINO_LOGGER = {
    :development => {:log_level => :debug, :stream => :stdout},
    :test => {:log_level => :debug, :stream => :to_file},
    :ci => {:log_level => :debug, :stream => :stdout},
    :qa => {:log_level => :debug, :stream => :stdout},
    :production => {:log_level => :info, :stream => :stdout},
    :e2e => {:log_level => :info, :stream => :stdout},
    :staging => {:log_level => :info, :stream => :stdout},
    :performance => {:log_level => :info, :stream => :stdout},

}

#
# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
#require 'action_dispatch'
require 'logger'
Bundler.require(:default, PADRINO_ENV)
include RACore

##
# Add your before (RE)load hooks here
Padrino.before_load do
end

##
# Enable devel logging
#
# Padrino::Logger::Config[:development] = { :log_level => :devel, :stream => :stdout }
# Padrino::Logger.log_static = true
#

##
# Add your after load hooks here
#
Padrino.after_load do
  Padrino.require_dependencies Padrino.root('lib/adaptors/*.rb')
  Padrino.require_dependencies Padrino.root('app/utils/*.rb')
  APP_CONFIG = YAML.load_file(Padrino.root('config', 'config.yml'))[PADRINO_ENV]
  puts "config= #{PADRINO_ENV} #{APP_CONFIG}"
  ENABLE_ET = APP_CONFIG['enable_et']

  #TODO: how do we get groupId

  PARTITION_ID = APP_CONFIG['partitioning_id']

  TOPIC_ID = APP_CONFIG['topic_id']
  PARTITION_COUNT = APP_CONFIG['partition_count']
  BUFFER_APP = APP_CONFIG['brokers']
  CLIENT_NAME = APP_CONFIG['ra-rb-buffer-producer']
end

Padrino.load!
