require 'machinist/active_record'
require 'sham'

Spec::Runner.configure do |config|
  config.before(:all)  { Sham.reset(:before_all) }
  config.before(:each) { Sham.reset(:before_each) }
end

Sham.define do
  name        { Faker::Lorem.words(1)   }
  city        { Faker::Address.city     }
  state       { Faker::Address.us_state }
  country     { Faker::Lorem.words(1)   }
  description { Faker::Lorem.paragraph  }
  email       { Faker::Internet.email   }
  username    { Faker::Internet.user_name }
  password    { Faker::Lorem.sentence   }
end

Community.blueprint do
  name        { Sham.city }
  state
  country
  description
end

User.blueprint do
  email
  username
  password
  password_confirmation { password }
end

Destination.blueprint do
  name
end

Group.blueprint do
  name
  owner       { User.make }
  destination
end
