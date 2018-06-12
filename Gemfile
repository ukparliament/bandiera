source 'https://rubygems.org'

gem 'rake'
gem 'dotenv'

gem 'sequel'
gem 'mysql2', platform: :ruby
gem 'pg', platform: :ruby
gem 'jdbc-mysql', platform: :jruby
gem 'jdbc-postgres', platform: :jruby

gem 'sinatra', '>= 2.0.2'
gem 'rack-flash3'
gem 'erubis'
gem 'macmillan-utils', '>= 1.0.41'
gem 'lru_redux'

gem 'puma', require: false

gem 'airbrake', require: false
gem 'statsd-ruby', require: false
gem 'newrelic_rpm'

group :development do
  gem 'shotgun'
end

group :test do
  gem 'rubocop', '>= 0.49.0'
  gem 'sqlite3', platform: :ruby
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'rspec'
  gem 'rack-test'
  gem 'capybara', '>= 2.15.1'
  gem 'poltergeist', '>= 1.16.0'
  gem 'webmock'
  gem 'pry'
  gem 'guard-rspec', require: false
  gem 'timecop'
end
