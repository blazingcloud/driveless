class Mode < ActiveRecord::Base
  attr_accessible :name, :green, :lb_co2_per_mile

  has_many :trips
end
