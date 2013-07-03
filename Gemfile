source 'http://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


gem 'therubyracer'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
# gems in just test and dev environments
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
  # To use debugger
  gem 'debugger'
  gem 'rack-mini-profiler'
  gem 'hirb'

end

group :development, :production do
  gem 'delayed_job_active_record'

  # Foreman is used on the cedar stack to run the web server and worker threads
  # we are still on bamboo, so we don't need it right now
  #
  # gem 'foreman'
end

gem 'pg'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails', '~> 2.0.2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'



group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'factory_girl_rails', '~> 4.0'
end

