class User < ActiveRecord::Base
  has_one :baseline

  has_many :modes, :through => :trips
  has_many :trips
  has_many :invitations
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "Group", :foreign_key => :owner_id
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  
  belongs_to :community
  
  validates_presence_of :email, :username, :name, :address, :city
  restful_easy_messages

  before_create :create_baseline

  named_scope :by_green_miles, :order => 'green_miles DESC'
  named_scope :by_lb_co2, :order => 'lb_co2 DESC'
  named_scope :in, lambda { |id| { :conditions => [ 'users.id IN (?)', id ] } }
  named_scope :filter_trip_destination, lambda { |id| { :conditions => [ 'trips.destination_id = ?', id ] }}

  named_scope :with_aggregated_stats_for_destination, {
    :select => ['users.id, users.username, users.community_id, sum(trips.distance) AS green_miles, max(modes.lb_co2_per_mile)*sum(trips.distance) AS lb_co2'],
    :joins => {:trips => :mode},
    :group => "trips.user_id, users.id, users.username, users.community_id"
  }

  attr_protected :admin

  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email]
    c.validate_password_field = true
  end # block optional

  def badges
    [
      (
        has_complete_baseline? ?
          ({
            :html_class => 'of-goal',
            :stat       => percent_of_personal_goal_reached.to_i,
            :label      => "% of goal",
          }) :
          ({
            :html_class => 'of-goal no-baseline',
            :stat       => '&nbsp;',
            :label      => "<a href='/baselines/#{baseline.id}/edit'>make a baseline</a>",
          })       
      ),
      {
        :html_class => 'non-green-miles',
        :stat       => non_green_miles.to_i,
        :label      => 'non-green miles'
      },
      {
        :html_class => 'green-miles',
        :stat       => green_miles.to_i,
        :label      => 'green miles',
      },
      {
        :html_class => 'carbon-saved',
        :stat       => lb_co2_saved,
        :label      => 'lb co2 saved',
      },
    ]
  end

  def has_complete_profile?
    username && email && name && address && city
  end
  
  def non_green_miles
    "%0.1f" % self.trips.not_green.map(&:distance).sum
  end
  
  def has_joined_groups?
    groups.count > 0
  end
  
  def has_complete_baseline?
    baseline.green_miles
  end
  
  def has_logged_trips?
    trips.count > 0
  end

  def has_completed_workflow?
    has_complete_profile? && has_joined_groups? && has_complete_baseline? && has_logged_trips?
  end

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

  def profile_complete?
    email.present? && username.present?
  end

  def newpass( len )
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      return newpass
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
