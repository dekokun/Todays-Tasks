require 'capistrano/ext/multistage'

set :application, "everyday_tasks"
set :repository,  "https://github.com/dekokun/Todays-Tasks.git"
set :branch,  "master"
set :deploy_to,  "$HOME/#{application}"
set :default_run_options, :pty => true
set :keep_releases, 5 #クリーンアップ時に残すソースの世代数


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do
    run "cd #{File.join(current_path)} && npm install && sudo forever restart #{File.join(current_path, "app.js")}"
  end
end
