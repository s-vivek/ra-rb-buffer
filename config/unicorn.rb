# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
service_name = ENV['SERVICE_NAME']
company = ENV['SUPPLY_CHAIN_COMPANY'] || "b2c"
package = "fk-#{service_name.gsub('_', '-')}"
unicorn_timeout = ENV['UNICORN_TIMEOUT'] || 600
puts "Starting unicorn for the company : #{company}, deploy_env : #{ENV['DEPLOY_ENV']}, padrino_env : #{ENV['PADRINO_ENV']}, port : #{ENV['PORT']}"

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 5

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

APP_PATH = File.expand_path(File.dirname(__FILE__) + "/..")

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory APP_PATH # available in 0.94.0+

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/sockets/.unicorn.sock", :backlog => 64
#listen APP_PATH + "/tmp/sockets/.unicorn.sock", :backlog => 64
listen ENV['PORT'].to_i + 5, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout unicorn_timeout.to_i

# feel free to point this anywhere accessible on the filesystem
pid "/tmp/pids/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so peobodyrevent them from going to /dev/null when daemonized here:
#stderr_path "/var/log/flipkart/supply-chain/#{package}/#{ENV['PADRINO_ENV']}.log"
#stdout_path "/var/log/flipkart/supply-chain/#{package}/#{ENV['PADRINO_ENV']}.log"

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  # defined?(ActiveRecord::Base) and
  #  ActiveRecord::Base.connection.disconnect!

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  # old_pid = "#{server.config[:pid]}.oldbin"
  # if old_pid != server.pid
  #   begin
  #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
  #     Process.kill(sig, File.read(old_pid).to_i)
  #   rescue Errno::ENOENT, Errno::ESRCH
  #   end
  # end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

unicorn_timeout = ENV['UNICORN_TIMEOUT'] || 600
timeout unicorn_timeout.to_i

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  puts "Padrino.env is #{Padrino.env}"
  # the following is *required* for Rails + "preload_app true",
  #defined?(ActiveRecord::Base) and
  #  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])

  #Oms.poll_config_with Oms.settings.min_config_poll_time, Oms.settings.max_config_poll_time do
  #    Oms.override_config!
  #    Oms.override_config!(SUPPLY_CHAIN_COMPANY)
  #end
  
  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
