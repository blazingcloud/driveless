class Destination < ActiveRecord::Base
  has_many :baseline_trips
  has_many :groups

  attr_accessible :name

  named_scope :by_name, :order => 'name'
end
