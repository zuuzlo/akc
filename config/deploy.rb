set :application, 'akc'
set :deploy_user, 'deploy'
#set :pty, true


# setup repo details
set :scm, :git
set :repo_url, 'git@github.com:zuuzlo/akc.git'

set :rvm_type, :user                     # Defaults to: :auto
#set :rvm_ruby_version, '2.2.1-p85'      # Defaults to: 'default'
#set :rvm_custom_path, '~/.rvm'  # only needed if not detected

#set :assets_roles, [:web, :app]
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'

set :format, :simpletext
# set :log_level, :debug
# set :pty, true

Airbrussh.configure do |config|
  config.color = true
  config.command_output = true
  # etc.
end

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  }
])

# reload nginx to it will pick up any modified vhosts from
# setup_config

after 'deploy:setup_config', 'nginx:reload'

namespace :deploy do



  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  #before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  #before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  #after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'

  after :updated, "assets:precompile"

  desc 'Runs rake db:seed'
  task :seed => [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end
end

namespace :rails do
  desc "Open the rails console on each of the remote servers"
  task :console => 'rvm:hook' do
    on roles(:app), :primary => true do |host|
      rails_env = fetch(:stage)
      execute_interactively host, "console #{rails_env}"
    end
  end

  desc "Open the rails dbconsole on each of the remote servers"
  task :dbconsole => 'rvm:hook' do
    on roles(:app), :primary => true do |host|
      rails_env = fetch(:stage)
      execute_interactively host, "dbconsole #{rails_env}"
    end
  end

  def execute_interactively(host, command)
    command = "cd #{fetch(:deploy_to)}/current && #{SSHKit.config.command_map[:bundle]} exec rails #{command}"
    puts command if fetch(:log_level) == :debug
    exec "ssh -l #{host.user} #{host.hostname} -p #{host.port || 22} -t '#{command}'"
  end
end

namespace :assets do
  desc "Precompile assets locally and then rsync to web servers"
  task :precompile do
    on roles(:web) do
      rsync_host = host.to_s # this needs to be done outside run_locally in order for host to exist
      run_locally do
        with rails_env: fetch(:stage) do
          execute :bundle, "exec rake assets:precompile"
        end
        execute "rsync -av --delete ./public/assets/ #{fetch(:user)}@#{rsync_host}:#{shared_path}/public/assets/"
        execute "rm -rf public/assets"
        # execute "rm -rf tmp/cache/assets" # in case you are not seeing changes
      end
    end
  end
end