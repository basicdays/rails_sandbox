# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'
set :chruby_ruby, 'ruby-3.1.2'

# Prevents error when running through IntelliJ run configuration
# https://github.com/mattbrictson/airbrussh/issues/96
set :format_options, truncate: false if IO.console.nil?

set :application, 'rails-sandbox'
set :repo_url, 'git@github.com:basicdays/rails-sandbox.git'

# Default branch is :master
set :branch, 'main'

# allow rails to migrate
set :migration_role, :app

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

set :puma_service_unit_name, fetch(:application)
set :nginx_config_name, "#{fetch(:application)}.nginx"

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
