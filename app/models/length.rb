class Length < ActiveRecord::Base
  has_one :trip
  has_one :mode
  has_one :unit
  attr_accessible :trip_id, :mode_id, :distance, :unit_id
  
  validates_numericality_of :distance, :greater_than_or_equal_to => 0
end
