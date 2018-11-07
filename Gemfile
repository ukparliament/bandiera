source 'https://rubygems.org'

gem 'rake'
gem 'dotenv'

gem 'sequel'
gem 'mysql2', platform: :ruby
gem 'pg', platform: :ruby
gem 'jdbc-mysql', platform: :jruby
gem 'jdbc-postgres', platform: :jruby

gem 'sinatra', '>= 2.0.0'
gem 'rack-flash3', '>= 1.0.5'
gem 'erubis'
gem 'macmillan-utils'
gem 'lru_redux'

gem 'puma', require: false

gem 'airbrake', require: false
gem 'statsd-ruby', require: false
gem 'newrelic_rpm'

group :development do
  gem 'shotgun', '>= 0.9.2'
end

group :test do
  gem 'rubocop'
  gem 'sqlite3', platform: :ruby
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'rspec'
  gem 'rack-test', '>= 0.7.0'
  gem 'capybara', '>= 2.15.1'
  gem 'poltergeist', '>= 1.16.0'
  gem 'webmock'
  gem 'pry'
  gem 'guard-rspec', require: false
  gem 'timecop'
end
