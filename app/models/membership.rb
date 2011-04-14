class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_presence_of   :user_id, :group_id
  validates_uniqueness_of :user_id, :scope => :group_id

  scope :except_owned_by, lambda { |owner_id| {:joins => :group, :conditions => ["groups.owner_id != ?", owner_id]} }
  scope :by_group_name, :joins => :group, :order => 'groups.name ASC'
end
