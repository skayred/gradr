role :app, %w{tdd-lti@193.166.24.77}
role :web, %w{tdd-lti@193.166.24.77}
role :db,  %w{tdd-lti@193.166.24.77}

set :branch, :master
set :stage, :production
set :rails_env, 'production'
set :passenger_restart_with_touch, true
#set :passenger_in_gemfile, true
#set :passenger_restart_with_sudo, true

set :deploy_to, '/home/tdd-lti/www/tdd-lti-server'

namespace :deploy do
  desc "regenerate sitemap"
  task :sitemap do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          #execute :bundle, :exec, :rake, 'sitemap:refresh'
        end
      end
    end
  end
end

#after 'deploy:finished', 'deploy:sitemap'