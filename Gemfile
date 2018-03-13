source 'https://rubygems.org'

gem 'rails', '~> 4.2'

gem 'jquery-rails'
gem 'figaro'
gem 'httparty'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-validator-rails'

gem 'puma', require: false

gem 'sidekiq'
gem 'sidekiq-cron'
gem 'redis-rails'

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
  gem 'rubocop'
end

group :test do
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'webmock'
end
