class User < ActiveRecord::Base
  has_one :baseline

  has_many :trips
  has_many :invitations
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "Group", :foreign_key => :owner_id
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  
  belongs_to :community
  
  validates_presence_of :email, :name, :address, :username
  restful_easy_messages

  before_create :create_baseline

  named_scope :by_green_miles, :order => 'green_miles DESC'

  attr_protected :admin

  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email]
  end # block optional

  def percent_of_personal_goal_reached
    "%.2f%" % (self.green_miles.to_f / self.baseline.green_miles.to_f * 100)
  end
  
  def lb_co2_saved
    "%.1f" % self.trips.only_green.map{|t| t.mode.lb_co2_per_mile * t.distance}.sum.to_f
  end

  def regular_memberships
    memberships.except_owned_by(self)
  end

  def create_group(params)
    owned_groups.create(params)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def deliver_friendship_notification!(friend)
    Notifier.deliver_friendship_notification(self, friend)
  end

  def send_invitation!( invitation )
   user_invitation = invitations.create( invitation )
   if !user_invitation.new_record?
     Notifier.deliver_join_invitation( self, invitation )
   else
     false
   end
  end

  def friendship_for( user )
    friendships.find_by_friend_id(user.id)
  end

  def friendship_to( user_id )
    friendships.create(:friend_id => user_id)
    friend = User.find_by_id( user_id )
    deliver_friendship_notification!( friend )
  end

  def unfriendship_to( id )
    friendships.destroy(id)
  end

  def update_green_miles
    self.update_attribute( :green_miles, self.trips.only_green.map(&:distance).sum )
  end

  def join(group)
    memberships.create(:group => group)
  end

  private

  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.username = registration["nickname"] if username.blank?
  end

  def create_baseline
    self.baseline = Baseline.create
  end
end
