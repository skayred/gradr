set :application, 'maintenance-server'
set :scm, :git
set :repo_url, 'ssh://git@bitbucket.org/skayred/tdd-lti.git'

set :keep_releases, 3
set :pty, true

set :default_stage, :development

set :linked_dirs, fetch(:linked_dirs, []) + %w{public/system} + %w{public/ckeditor_assets} + %w{public/images}

set :rvm_type, :system
set :rvm_ruby_version, '2.6.3'

# before 'deploy:assets:precompile', 'npm:inst'

namespace :deploy do
  task :restart do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :bundle, :exec, :rake, 'npm:install'
          # execute :bundle, :exec, :rake, 'assets:precompile'
          # execute :bundle, :exec, :rake, 'assets:non_digested'
        end
      end
    end
  end

  after :publishing, :restart
end

namespace :deploy do
  desc "regenerate sitemap"
  task :sitemap do
    on roles(:all), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :bundle, :exec, :rake, 'npm:install'
        end
      end
    end
  end

  # after :finishing, :sitemap
end