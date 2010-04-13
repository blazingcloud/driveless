class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  belongs_to :owner, :class_name => "User"
  belongs_to :destination

  validates_presence_of :name, :owner_id, :destination_id
end
