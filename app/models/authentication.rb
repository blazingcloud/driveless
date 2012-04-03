# Represents a method that a User authenticates (Facebook, Twitter, etc)
# Current only using Facebook
class Authentication < ActiveRecord::Base
  belongs_to :user
end
