web: bundle exec rackup config.ru -p $PORT
redis: redis-server
backlog: bundle exec sidekiq -r./config/environment.rb