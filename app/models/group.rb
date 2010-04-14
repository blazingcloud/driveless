class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  belongs_to :owner, :class_name => "User"
  belongs_to :destination

  after_create :create_membership

  validates_presence_of :name, :owner_id, :destination_id

  def create_membership
    membership = Membership.new({:user_id => self.owner_id, :group_id => self.id})
    membership.save
  end
end
