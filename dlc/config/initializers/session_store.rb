# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dlc_session',
  :secret      => '5c2940ae46a7b7c9a3fdcda17aaf6252b820083de3f7e074b9d81c9a7cb29ed95d41e5d86c11710e1a6c96b415f91d69932990fbbb6ad3dcfb3b792f9fafc676'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
