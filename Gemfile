source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '~>3.0.5'
gem 'haml', '3.1.0.alpha.147'
gem 'compass'
gem 'compass-960-plugin'
gem 'inherited_resources', '~>1.2.1'
gem "will_paginate", "~> 3.0.pre2"
gem 'formtastic', '~>1.2.3' # latest as of 2011-04-13
gem 'googlecharts', '~>1.6.1' #, :require => "gchart"
gem 'hoptoad_notifier'
gem 'dynamic_form'
gem 'devise'
gem 'jquery-rails'
gem 'escape_utils'
#gem 'omniauth' # included in devise 1.5

gem 'omniauth-facebook'
#group :assets do
#  gem 'compass-rails'
#end

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'machinist'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'rr'
  gem 'sqlite3'
  gem 'email_spec'
end

group :development do
  gem 'heroku'
  gem 'taps'
  gem 'pivotal_git_scripts'
end

group :production do
  gem 'pg', '0.11.0' # Not using ~> because when pg is installed it needs ARCHFLAGS="-arch x86_64"
end
