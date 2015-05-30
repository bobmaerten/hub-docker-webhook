require_relative 'app'
require 'sidekiq/web'

set :environment, ENV['RACK_ENV'].to_sym
set :app_file, 'app.rb'

run Rack::URLMap.new \
    '/'        => Sinatra::Application,
    '/sidekiq' => Sidekiq::Web
