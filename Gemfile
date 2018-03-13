# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 4.2'

gem 'bootstrap-validator-rails'
gem 'figaro'
gem 'httparty'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

gem 'puma', require: false

gem 'redis-rails'
gem 'sidekiq'
gem 'sidekiq-cron'

gem 'maestrano-connector-rails', '~> 2.3.0'

gem 'omniauth-shopify-oauth2', '~> 1.1'
gem 'shopify_api'

gem 'newrelic_rpm'

gem 'activeadmin'
gem 'jsonapi-resources'
gem 'pundit'
gem 'pundit-resources'

group :production, :uat do
  gem 'mysql2'
  gem 'rails_12factor'
end

group :test, :develpment do
  gem 'sqlite3'

  # Style check
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'timecop'
  gem 'webmock'
end
