class Mode < ActiveRecord::Base

  attr_accessible :name, :green, :lb_co2_per_mile, :description

  has_many :trips

  scope :by_name, :order => 'modes.name'
  scope :green, where(:green => true)
end
