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
  has_many :messages, :foreign_key => :receiver_id
  
  belongs_to :community
  
  validates_acceptance_of :is_13, :allow_nil => false, :accept => true
  validates_acceptance_of :read_privacy, :allow_nil => false, :accept => true

  validates_presence_of :email, :username, :name, :address, :city, :zip

  before_create :create_baseline

  attr_protected :admin

  acts_as_authentic 

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

  def self.find_leaderboard(user_ids_sql, filter_id, order = :miles, mode_id = nil)
    order_sql = order == :lb_co2 ? 'lb_co2_sum' : 'distance_sum'

    modes_filter_sql = mode_id.nil? ? "" : sanitize_sql_for_conditions(["AND trips.mode_id = ?", mode_id])

    sql = <<-SQL
      SELECT users.*, distance_sum, lb_co2_sum FROM users
      INNER JOIN (

      SELECT user_id, sum(lb_co2_per_mode_sum) AS lb_co2_sum, sum(distance_per_mode_sum) AS distance_sum FROM (
        SELECT trips.user_id, trips.mode_id, (modes.lb_co2_per_mile * sum(trips.distance)) AS lb_co2_per_mode_sum, sum(trips.distance) AS distance_per_mode_sum FROM trips
        INNER JOIN modes ON trips.mode_id = modes.id
        WHERE trips.user_id IN
        (#{user_ids_sql})
        AND modes.green = ?
        #{modes_filter_sql}
        GROUP BY trips.user_id, trips.mode_id, modes.lb_co2_per_mile) AS stats_per_mode
      GROUP BY user_id) AS stats_per_user

      ON stats_per_user.user_id = users.id
      ORDER BY #{order_sql} DESC
    SQL

    find_by_sql([sql, filter_id, true])
  end

  def friends_leaderboard(order = :miles)
    user_ids_sql = "SELECT friend_id FROM friendships WHERE user_id = ?"

    self.class.find_leaderboard(user_ids_sql, id, order)
  end

  def friends_leaderboard_by(mode_id)
    user_ids_sql = "SELECT friend_id FROM friendships WHERE user_id = ?"

    self.class.find_leaderboard(user_ids_sql, id, :miles, mode_id)
  end

  def fans_leaderboard(order = :miles)
    user_ids_sql = "SELECT user_id FROM friendships WHERE friend_id = ?"

    self.class.find_leaderboard(user_ids_sql, id, order)
  end

  def fans_leaderboard_by(mode_id)
    user_ids_sql = "SELECT user_id FROM friendships WHERE friend_id = ?"

    self.class.find_leaderboard(user_ids_sql, id, :miles, mode_id)
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

  def create_group(params, dont_become_member = false)
    group = owned_groups.create(params)
    group.memberships.create!(:user => self) unless dont_become_member || group.new_record?
    group
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

  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    self.username = facebook_session.user.name
    self.is_13 = true
    self.read_privacy = true
    self.email = 'facebook+temporary@my.drivelesschallenge.com'
    self.address = 'Replace me!'
    self.city = 'Replace me!'
    self.zip = 'Replace me!'
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
