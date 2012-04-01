require 'app'

set :environment, ENV['RACK_ENV'].to_sym
set :app_file,     'app.rb'

log = File.new("logs/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Controller.new
