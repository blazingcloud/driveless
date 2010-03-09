# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dlc_session',
  :secret      => 'deb2364a6366ce982b6a77ddb996f179cdc2383e99aa926bc41d7c682af9bfaf1e1a5f3e9ddb84ba4da8a9985198fc93aa3e4446a234d16d12a9d02e3d364af4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
