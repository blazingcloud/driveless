class BaselineTrips < ActiveRecord::Base
  attr_accessible :baseline_id, :destination_id, :unit_id, :alone, :green
end
