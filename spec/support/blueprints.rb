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
  zip         { Faker::Address.zip_code }
  country     { Faker::Lorem.words(1)   }
  description { Faker::Lorem.paragraph  }
  invitation  { Faker::Lorem.paragraph  }
  email       { Faker::Internet.email   }
  username    { Faker::Internet.user_name }
  password    { Faker::Lorem.sentence   }
  address     { Faker::Address.street_address  }
  person_name { Faker::Name.name        }
  lb_co2_per_mile { rand }
  distance        { rand(10) + 1 }
end

# Same ordering as db/schema.rb.
Baseline.blueprint do # Light model, blueprint as place holder.
  user
  duration
end

Community.blueprint do
  name        { Sham.name }
  state       { Sham.state }
  country     { Sham.country }
  description { Sham.description }
end

Destination.blueprint do
  name        { Sham.name }
end

Friendship.blueprint do
  user        { User.make } 
  friend
end

Group.blueprint do
  name        { Sham.name }
  owner       { User.make } 
  description { Sham.description }
  destination { Sham.city }
end

Invitation.blueprint do
  name        { Sham.name }
  email       { Sham.email }
  invitation  { Sham.invitation }
  user
end

Length.blueprint do
  trip
  mode
  distance    { Sham.distance }
  unit        { Unit.first || Unit.make }
end

Membership.blueprint do
  user
  group
end

Message.blueprint do
  receiver
  sender
  subject
  body
end

Mode.blueprint do
  name        { Sham.person_name }
  green       true
  lb_co2_per_mile
end

Trip.blueprint do
  user
  destination { Sham.ncity }
  mode
  distance    { Sham.distance }
  unit        { Unit.first || Unit.make }
end

Unit.blueprint do # This is useless!
  name        { Sham.name }
  in_miles    1
end

User.blueprint do
  email                 { Sham.email }
  username              { Sham.username }
  password
  password_confirmation { password }
  name                  { Sham.person_name }
  address               { Sham.address }
  city                  { Sham.city }
  zip                   { Sham.zip }
  is_13                 true
  read_privacy          true
end