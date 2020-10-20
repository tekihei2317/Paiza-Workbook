# config valid for current version and patch releases of Capistrano
lock '~> 3.14.1'

# ファイルを配置するための設定
set :application, 'paiza-workbook'
set :repo_url, 'git@github.com:tekihei2317/paiza-workbook.git'
set :deploy_to, '/var/www/app/paiza-workbook'

# masterブランチ以外をデプロイする場合は、環境変数BRANCHで指定する
set :branch, ENV['BRANCH'] || 'master'

# rbenvの設定
set :rbenv_type, :user
set :rbenv_ruby, '2.7.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} #{fetch(:rbenv_path)}/bin/rbenv exec"

# bundlerの設定
append :linked_dirs, '.bundle'

# 共有ファイルの設定
append :linked_files, 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'

# puma:nginx_configでエラーが出るので追記
set :pty, true

# crontabを更新する
set :whenever_command, 'bundle exec whenever'
# set :whenever_roles, -> { :app }

# after 'deploy:finishing', 'deploy:restart_puma'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

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
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
