require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/sidekiq'
#require 'capistrano/sidekiq/monit'
require 'capistrano/rails/console'

require 'capistrano/puma'
install_plugin Capistrano::Puma
#install_plugin Capistrano::Puma::Monit

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }