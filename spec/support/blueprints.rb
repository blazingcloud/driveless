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
  user_id
  duration
end

Community.blueprint do
  name        { Sham.city }
  state
  country
  description
end

Destination.blueprint do
  name
end

Friendship.blueprint do
  user_id
  friend_id
end

Group.blueprint do
  name
  owner       { User.make }
  destination
  description
end

Invitation.blueprint do
  email
  user_id
  invitation
  name
end

Length.blueprint do
  trip_id
  mode_id
  distance
  unit_id
end

Membership.blueprint do
  user_id
  group_id
end

Message.blueprint do
  receiver_id
  sender_id
  subject
  body
end

Mode.blueprint do
  name
  green           true
  lb_co2_per_mile
end

Trip.blueprint do
  user
  destination
  mode
  distance
  unit        { Unit.first || Unit.make }
end

Unit.blueprint do # This is useless!
  name
  in_miles 1
end

User.blueprint do
  email
  username
  password
  password_confirmation { password }
  name      { Sham.person_name }
  address
  city
  is_13     true
  read_privacy true
  zip
end