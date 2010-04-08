class Trip < ActiveRecord::Base
  belongs_to :user
  belongs_to :destination
  belongs_to :mode
  belongs_to :unit
  attr_accessible :user_id, :destination_id, :mode_id, :unit_id, :distance, :made_at
end
