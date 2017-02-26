# config valid only for current version of Capistrano
# require 'capistrano-db-tasks'



server "185.25.118.190", user: 'root', roles: %w{web app db}
set :user, "root"

set :application, "lib_agregator"
set :repo_url, "https://github.com/isidzukuri/lib_agregator.git"
set :deploy_to, '/var/www/lib_agregator'

# Don't change these unless you know what you're doing
set :pty,             true
# set :use_sudo,        false
# set :deploy_via,      :remote_cache
set :puma_bind,       "unix:///tmp/lib_agregator.sock"
set :puma_state,      "/tmp/lib_agregator_puma.state"
set :puma_pid,        "/tmp/lib_agregator_puma.pid"

set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_init_active_record, true  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"


namespace :deploy do

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma




























# lock "3.7.2"

# set :application, "lib_agregator"
# set :repo_url, "https://github.com/isidzukuri/lib_agregator.git"
# set :deploy_to, '/var/www/lib_agregator'



# # RVM
# # set :rvm_ruby_version, 'ruby-2.4.0'


# set :user, "root"
# server "185.25.118.190", user: 'root', roles: %w{web app db}

# # Default branch is :master
# # ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# # Default deploy_to directory is /var/www/my_app_name
# # set :deploy_to, "/var/www/my_app_name"

# # Default value for :format is :airbrussh.
# # set :format, :airbrussh

# # You can configure the Airbrussh format using :format_options.
# # These are the defaults.
# # set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# # Default value for :pty is false
# # set :pty, true

# # Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# # Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# # Default value for default_env is {}
# # set :default_env, { path: "/opt/ruby/bin:$PATH" }

# # Default value for keep_releases is 5
# # set :keep_releases, 5
