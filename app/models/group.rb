class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  belongs_to :owner, :class_name => "User"
  belongs_to :destination

  after_create :create_owner_membership

  validates_presence_of :name, :owner_id, :destination_id
  validates_uniqueness_of :name

  named_scope :by_name , :order => 'name ASC'

  def membership_for(user)
    memberships.find_by_user_id(user.id)
  end

  def create_owner_membership
    memberships.create!(:user_id => self.owner_id)
  end

  def owned_by?(user)
    owner_id == user.id
  end
end
