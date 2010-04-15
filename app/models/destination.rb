class Destination < ActiveRecord::Base
  has_many :groups

  attr_accessible :name

  named_scope :by_name, :order => 'name'
end
