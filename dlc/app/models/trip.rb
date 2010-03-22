class Trip < ActiveRecord::Base
  has_one :user
  has_one :destination
  attr_accessible :user_id, :destination_id
end
