# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'dotenv-rails'
gem 'mysql2', '>= 0.4.4'
gem 'omniauth', '~> 1.9.1'
gem 'omniauth-google-oauth2'
gem 'pg'
gem 'puma', '~> 5.1'
gem 'rails', '~> 6.1'

# frontend
gem 'bootstrap', '~> 4.4'
gem 'jquery-rails'
gem 'sass-rails', '>= 6'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rails-controller-testing'
  gem 'rspec-rails', '4.0'
end

group :development do
  gem 'coveralls', '~> 0.8.23', require: false
  gem 'listen', '~> 3.4'
  gem 'rubocop', '~> 0.79', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', '~> 0.16.1', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
