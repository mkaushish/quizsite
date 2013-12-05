source 'http://rubygems.org'

gem 'rails', '3.2.13'

gem 'therubyracer', :platform => :ruby
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
gem 'pg'
gem 'jquery-rails', '~> 2.0.2'
gem 'ransack'
gem 'will_paginate', '~> 3.0'
gem 'auto_html'
gem "google_visualr"

group :test, :development do
	gem 'rspec-rails'
    #gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
    gem 'database_cleaner'
    gem 'launchy'
    gem 'guard-rails'
end

group :development do
	#gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
    gem 'guard-livereload'
    gem 'rails-dev-tweaks', '~> 0.6.1'
    gem 'thin'
    gem "better_errors"
    gem "binding_of_caller"
    gem 'quiet_assets'
    #gem 'debugger'
    #gem 'rack-mini-profiler'
    gem 'hirb'
    gem "mailcatcher", "~> 0.5.12"
end

group :development, :production do
    gem 'delayed_job_active_record'
end

group :assets do
    gem 'sass-rails', "  ~> 3.2.3"
    gem 'coffee-rails', "~> 3.2.1"
    gem 'uglifier', ">= 1.0.3"
    gem 'compass-rails'
end

group :test do
  gem 'turn', :require => false
  gem 'factory_girl_rails', '~> 4.0'
end