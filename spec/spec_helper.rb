# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  config.mock_with :rr
  #config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def login_as(user, password="password")
  visit destroy_user_session_path
  visit new_user_session_path
  fill_in 'Email', :with => user.email
  fill_in 'Password', :with => password
  click_button 'Login'
end

def login_as_admin
  admin = User.make(:password => "password")
  admin.update_attribute(:admin, true)
  admin.reload.should be_admin
  login_as(admin, "password")
  admin
end

def user_with_trips(options)
  user = options[:user] || User.make
  user.community = options[:community]
  user.save!
  distances = options[:distances] || [1.0, 2.0, 3.0, 4.0, 5.0]
  mode = options[:mode]
  destination = options[:destination]
  date = EARTH_DAY_2012
  distances.each do |distance|
    user.trips.create!(:destination_id => destination.id, :unit_id => Unit.first.id, :mode_id => mode.id,
                       :distance => distance, :made_at => date)
    date += 1.day
  end
  user
end

EARTH_DAY_2012 = Date.new(2012, 4, 22)

def add_trips_to_user(user, options)
  distances = options[:distances] || [1.0, 2.0, 3.0, 4.0, 5.0]
  mode = options[:mode]
  destination = options[:destination]
  date = EARTH_DAY_2012
  distances.each do |distance|
    Trip.create!(:destination_id => destination.id, :unit_id => Unit.first.id, :mode_id => mode.id,
                 :distance => distance, :made_at => date, :user_id => user.id)
    date += 1.day
  end
  User.find_by_id(user.id)
end
