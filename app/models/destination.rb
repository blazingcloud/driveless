class Destination < ActiveRecord::Base
  has_many :baseline_trips
  attr_accessible :name
end
