#!/usr/bin/env puma

directory '/var/www/rails-sandbox/current'
rackup "/var/www/rails-sandbox/current/config.ru"
environment 'vbox'

tag ''

pidfile "/var/www/rails-sandbox/shared/tmp/pids/puma.pid"
state_path "/var/www/rails-sandbox/shared/tmp/pids/puma.state"
stdout_redirect '/var/www/rails-sandbox/shared/log/puma_access.log', '/var/www/rails-sandbox/shared/log/puma_error.log', true


threads 0,16



bind 'unix:///var/www/rails-sandbox/shared/tmp/sockets/puma.sock'

workers 0




restart_command 'bundle exec puma'


prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end


