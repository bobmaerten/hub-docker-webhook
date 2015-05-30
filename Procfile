redis:    redis-server /usr/local/etc/redis.conf
workers:  bundle exec sidekiq -r ./worker.rb
web:      bundle exec rackup config.ru
