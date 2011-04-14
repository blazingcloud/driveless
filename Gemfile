source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '~>3.0.5'
gem 'haml', '~>3.0.25' # latest as of 2011-04-13
gem 'compass'
gem 'authlogic'
#gem 'authlogic-oid', :require => "authlogic_openid"
gem 'inherited_resources', '~>1.2.1'
gem 'will_paginate'
gem 'formtastic', '~>1.2.3' # latest as of 2011-04-13
gem 'googlecharts', '~>1.6.1' #, :require => "gchart"
#gem 'facebooker', '~>1.0.75'
#gem 'ruby-openid', '>= 2.0.4'
#gem 'authlogic-connect', '0.0.6',
    #:git => "https://github.com/blazingcloud/authlogic-connect.git",
    #:branch => "fix"

group :production do
  gem 'hoptoad_notifier'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'machinist'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'rr'
  gem 'ruby-debug'
  gem 'sqlite3'
end

group :development do
  gem 'heroku', '~>1.20.1'
end
