class Mode < ActiveRecord::Base

  attr_accessible :name, :green, :lb_co2_per_mile, :description

  has_many :trips

  named_scope :by_name, :order => 'modes.name'
end
