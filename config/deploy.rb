server "185.25.118.190", user: 'root', roles: %w{web app db}
set :user, "root"

set :application, "lib_agregator"
set :repo_url, "https://github.com/isidzukuri/lib_agregator.git"
set :deploy_to, '/var/www/lib_agregator'

append :linked_dirs, 'public/uploads'

append :linked_files, "config/database.yml", "config/secrets.yml", "public/sd-feed-269.xml"