# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'active_model_serializers', '~> 0.10.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coderay'
gem 'devise'
gem 'devise-bootstrap-views'
gem 'enumerize'
gem 'faraday'
gem 'global'
gem 'haml-rails'
gem 'json-schema'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.1'
gem 'redcarpet', '~> 2.3.0'
gem 'sass-rails'
gem 'seed-fu'
gem 'slack-notifier'
gem 'turbolinks'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7.4'
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'debase'
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rails-erd'
  gem 'rubocop', require: false
  gem 'ruby-debug-ide'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  # gem "capybara", ">= 2.15"
  # gem "selenium-webdriver"
  # gem "chromedriver-helper"
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
