class Baseline < ActiveRecord::Base
  has_many :baseline_trips
  has_one :destination
  attr_accessible :user_id, :duration
end
