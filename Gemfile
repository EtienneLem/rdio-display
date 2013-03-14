source 'http://rubygems.org'
ruby '2.0.0'

# Server
gem 'unicorn'

# App
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'erubis'

# Development
group :development do
  gem 'awesome_print'
end

# Production
group :production do
  gem 'newrelic_rpm'
end

# Assets
group :assets do
  gem 'sprockets'
  gem 'coffee-script'
  gem 'stylus', '~> 0.7.1', :require => 'stylus/sprockets'
  gem 'uglifier'
end
