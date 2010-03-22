class BaselineTrips < ActiveRecord::Base
  belongs_to :baseline
  has_one :unit
  has_one :destination
  attr_accessible :baseline_id, :destination_id, :unit_id, :alone, :green
end
