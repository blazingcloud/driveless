class Community < ActiveRecord::Base
  has_many :results
  has_many :users
  validates_presence_of :name, :state, :country

  before_destroy :ensure_there_are_no_members

  # Is there any 'rubiest' way to do this?
  scope :by_green_miles,
    :select => ['communities.id, communities.name, communities.state, communities.country, 
      communities.description, SUM(users.green_miles) as green_miles, SUM(users.green_miles)*modes.lb_co2_per_mile'],
    :joins => [:users => {:trips => :mode}],
    :group => ['communities.id, users.community_id, trips.user_id, communities.name, communities.state, communities.country, communities.description, modes.lb_co2_per_mile']

  def self.find_leaderboard(order = :miles)
    order_sql = order.to_sym == :lb_co2 ? 'lb_co2_sum' : 'distance_sum'

    sql = <<-SQL
      SELECT communities.*, COALESCE(distance_sum, 0) AS distance_sum, COALESCE(lb_co2_sum, 0) AS lb_co2_sum FROM communities
      LEFT JOIN (

      SELECT community_id, sum(lb_co2_per_mode_sum) AS lb_co2_sum, sum(distance_per_mode_sum) AS distance_sum FROM (
        SELECT users.community_id, trips.mode_id, (modes.lb_co2_per_mile * sum(trips.distance)) AS lb_co2_per_mode_sum, sum(trips.distance) AS distance_per_mode_sum FROM trips
        INNER JOIN users ON trips.user_id = users.id
        INNER JOIN modes ON trips.mode_id = modes.id
        WHERE modes.green = ?
        AND trips.made_at >= ?
        GROUP BY users.community_id, trips.mode_id, modes.lb_co2_per_mile) AS stats_per_mode
      GROUP BY community_id) AS stats_per_community

      ON stats_per_community.community_id = communities.id
      ORDER BY #{order_sql} DESC
    SQL

    find_by_sql([sql, true, Date.new(2012, 4, 22)])
  end

  def stats
    return @stats if @stats

    sql = <<-SQL
      SELECT communities.id, sum(lb_co2_per_mode_sum) AS lb_co2_sum, sum(distance_per_mode_sum) AS distance_sum FROM communities
      INNER JOIN (

        SELECT users.community_id, trips.mode_id, (modes.lb_co2_per_mile * sum(trips.distance)) AS lb_co2_per_mode_sum, sum(trips.distance) AS distance_per_mode_sum FROM trips
        INNER JOIN users ON trips.user_id = users.id
        INNER JOIN modes ON trips.mode_id = modes.id
        WHERE users.community_id = ?
        AND modes.green = ?
        AND trips.made_at >= ?
        GROUP BY users.community_id, trips.mode_id, modes.lb_co2_per_mile) AS stats_per_mode

      ON stats_per_mode.community_id = communities.id
      GROUP BY communities.id
    SQL

    c = self.class.find_by_sql([sql, id, true, Date.new(2012, 4, 22)])[0]

    @stats = {
      :lb_co2_sum   => c.nil? ? 0 : c.lb_co2_sum,
      :distance_sum => c.nil? ? 0 : c.distance_sum
    }
  end

  def badges
    s = stats
    [
      {
        :stat => users.length,
        :label => users.length == 1 ? 'member' : 'members'
      },
      {
        :stat => s[:distance_sum].to_i,
        :label => 'green miles'
      },
      {
        :stat => "%.1f" % s[:lb_co2_sum].to_f,
        :label => 'lb co2 saved'
      }
    ]
  end

  def green_miles
     self.users.map{|u| u.green_miles.to_f}.sum
  end

  def members_leaderboard(order)
    user_ids_sql = "SELECT id FROM users WHERE community_id = ?"

    User.find_leaderboard(user_ids_sql, id, order)
  end

  def members_leaderboard_by(mode_id)
    user_ids_sql = "SELECT id FROM users WHERE community_id = ?"

    User.find_leaderboard(user_ids_sql, id, :miles, mode_id)
  end

  def lb_co2_saved
     self.users.map{|u| u.lb_co2_saved.to_f}.sum
  end

  private

  def ensure_there_are_no_members
    raise "This community can't be deleted as there are #{users.count} users in it" if users.any?
  end
end
