class Trip < ActiveRecord::Base
  has_one :user
  has_one :destination
  has_one :mode
  attr_accessible :user_id, :destination_id, :mode_id
end
