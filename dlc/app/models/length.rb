class Length < ActiveRecord::Base
  has_one :trip
  has_one :mode
  has_one :unit
  attr_accessible :trip_id, :mode_id, :distance, :unit_id
end
