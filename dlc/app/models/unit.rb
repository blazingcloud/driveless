class Unit < ActiveRecord::Base
  has_many :trips
  attr_accessible :name, :in_miles
end
