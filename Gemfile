source 'https://rubygems.org'

gem 'rake'
gem 'dotenv'

gem 'sequel'
gem 'mysql2', platform: :ruby
gem 'pg', platform: :ruby
gem 'jdbc-mysql', platform: :jruby
gem 'jdbc-postgres', platform: :jruby

gem 'sinatra'
gem 'rack-flash3'
gem 'erubis'
gem 'macmillan-utils'
gem 'lru_redux'

gem 'puma', require: false

gem 'airbrake', require: false
gem 'statsd-ruby', require: false
gem 'newrelic_rpm'

group :development do
  gem 'shotgun'
end

group :test do
  gem 'rubocop'
  gem 'sqlite3', platform: :ruby
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'rspec'
  gem 'rack-test'
  gem 'capybara', '>= 2.15.1'
  gem 'poltergeist', '>= 1.16.0'
  gem 'webmock'
  gem 'pry', '>= 0.10.4'
  gem 'guard-rspec', '>= 4.7.3', require: false
  gem 'timecop'
end
