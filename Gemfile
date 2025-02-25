source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password
# [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma
# [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants
# [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

gem 'devise', '~> 4.9'

gem 'pagy', '~> 9.3'

gem 'pundit', '~> 2.4'

gem 'ransack', '~> 4.2'

gem 'view_component', '~> 3.21'

gem 'heroicon', '~> 1.0'

gem 'activeadmin', '~> 4.0.0.beta15'

gem 'importmap-rails', '~> 2.1'

gem 'stripe', '~> 13.4'

# OmniAuth
gem 'omniauth', '~> 2.1'
gem 'omniauth-facebook', '~> 10.0'
gem 'omniauth-google-oauth2', '~> 1.2'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

gem 'pretender', '~> 0.5.0'

group :development, :test do
  # See
  # https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Linters
  gem 'rails_best_practices', '~> 1.23'
  gem 'reek', '~> 6.4'
  gem 'rubocop', '~> 1.70'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'actioncable', '~> 8.0'
  gem 'letter_opener', '~> 1.10'
  gem 'listen', '~> 3.9'
  gem 'lookbook', '~> 2.3'
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

gem "webauthn", "~> 3.4"
