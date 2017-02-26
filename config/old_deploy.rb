require "bundler/capistrano"
set :application, "lib_agregator"
# set :repository,  "set your repository location here"

# set :scm, :none
# set :repository, "."
# set :deploy_via, :copy
set :scm, :gitcopy

set :rails_env, "production"
set :deploy_to, '/var/www/lib_agregator'


# set :linked_files, %w{config/schedule.rb}
# set :shared_children, shared_children + %w{public/uploads public/images/photo public/images/avatar public/gpx}


set :user, "root"
server "185.25.118.190", :app, :web, :db, :primary => true




namespace :deploy do

  desc "Start the application"
  task :start, :roles => :app, :except => { :no_release => true } do
  	run "cd #{current_path} && bundle exec puma -C config/puma.rb"
  end

  desc "Stop the application"
  task :stop, :roles => :app, :except => { :no_release => true } do
  	run "cd #{current_path} && bundle exec pumactl -p /tmp/lib_agregator_puma.pid stop"
  end

  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
  	run "cd #{current_path} && bundle exec pumactl -p /tmp/lib_agregator_puma.pid restart"
  end

 # 	desc "Set crons"
	# task :set_crons, :roles => :app, :except => { :no_release => true } do
 #  	run "crontab -r"
 #  	run "cd #{current_path} && whenever --update-crontab"
 #  end

end

after "deploy", "deploy:cleanup"
# after "deploy", "deploy:set_crons"

# after "deploy", "deploy:stop"
# after "deploy", "deploy:start"

# bundle exec puma -e development -b unix:///tmp/social_network.sock



# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts


# namespace :deploy do
# 	task :bundle_install
# 		exec "bundle bundle_install"
# 	end
# end


# after "deploy", "deploy:bundle_install"

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end