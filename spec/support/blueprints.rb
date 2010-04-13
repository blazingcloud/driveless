require 'machinist/active_record'
require 'sham'

Spec::Runner.configure do |config|
  config.before(:all)  { Sham.reset(:before_all) }
  config.before(:each) { Sham.reset(:before_each) }
end

Sham.define do
  city        { Faker::Address.city     }
  state       { Faker::Address.us_state }
  country     { Faker::Lorem.words(1)   }
  description { Faker::Lorem.paragraph  }
end

Community.blueprint do
  name        { Sham.city }
  state
  country
  description
end
