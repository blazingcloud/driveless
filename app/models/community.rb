class Community < ActiveRecord::Base
  has_many :users
  validates_presence_of :name, :state, :country

  before_destroy :ensure_there_are_no_members

  # Is there any 'rubiest' way to do this?
  named_scope :by_green_miles,
    :select => ['communities.id, communities.name, communities.state, communities.country, 
      communities.description, SUM(users.green_miles) as green_miles, SUM(users.green_miles)*modes.lb_co2_per_mile'],
    :joins => [:users => {:trips => :mode}],
    :group => ['communities.id, users.community_id, trips.user_id, communities.name, communities.state, communities.country, communities.description, modes.lb_co2_per_mile']

  def green_miles
     self.users.map{|u| u.green_miles.to_f}.sum
  end

  def members_leaderboard(order)
    user_ids_sql = "SELECT id FROM users WHERE community_id = ?"

    User.find_leaderboard(user_ids_sql, id, order)
  end

  def members_leaderboard_by(mode_id)
    user_ids_sql = "SELECT id FROM users WHERE community_id = ?"

    User.find_for_leaderboard(mode_id, user_ids_sql, id)
  end

  def lb_co2_saved
     self.users.map{|u| u.lb_co2_saved.to_f}.sum
  end

  private

  def ensure_there_are_no_members
    raise "This community can't be deleted as there are #{users.count} users in it" if users.any?
  end
end
