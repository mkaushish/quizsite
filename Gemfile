source 'http://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'therubyracer'

# gems in just test and dev environments
group :test, :development do
	gem 'rspec-rails'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'guard-rails'
end

group :development do
	gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'guard-livereload'
end

group :development, :production do
  gem 'delayed_job_active_record'

  # Foreman is used on the cedar stack to run the web server and worker threads
  # we are still on bamboo, so we don't need it right now
  #
  # gem 'foreman'
end

# heroku uses postgresssql
group :production do
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'factory_girl_rails', :git => 'https://github.com/thoughtbot/factory_girl_rails.git'
end

