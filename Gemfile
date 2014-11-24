source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.18'

#Database ('pg' ideal for use with Heroku, but requires setting up)
gem 'sqlite3'
gem 'thin', '~> 1.6.0'

#Users!
gem 'devise', '2.2.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

#Interface
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.3.1.0'
gem 'select2-rails'
gem 'simple_form'

#Testing
gem 'factory_girl_rails', '~> 4.2.1'
gem 'forgery', '0.5.0'
gem 'ffaker'
gem 'watir-webdriver', "~>0.6.9"
gem 'headless'
gem 'capybara'
group :test, :development do
  gem 'better_errors'
  gem 'pry'
  gem 'pry-stack_explorer'
  gem 'pry-nav'
  gem 'pry-coolline'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov'
end
group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end