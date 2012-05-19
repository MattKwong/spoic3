source 'http://rubygems.org'

gem 'rails', '3.0.12'
gem 'jquery-rails'
gem 'rake', '0.9.2.2'
gem 'haml'
gem 'formtastic',  '2.1.1'
gem 'activeadmin'
gem 'simple-navigation'
gem 'validates_timeliness'
gem 'cancan'
gem 'prawn_rails'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'fastercsv'
gem 'rspec-rails', :group => [:development, :test]
gem 'rails3-jquery-autocomplete'
gem 'ruby-units'

group :production, :staging do
  gem "pg"
end

group :development do
  gem 'faker', '0.3.1'
  gem 'sqlite3-ruby', :require => 'sqlite3'
#  gem 'annotate-models', '1.0.4'
end

group :test do
  gem 'spork-rails', '3.2.0'
  gem 'webrat', '0.7.1'
  gem 'factory_girl_rails'
  gem "capybara"
  gem "guard-rspec"
  gem 'database_cleaner'
  gem 'sqlite3-ruby', :require => 'sqlite3'
end