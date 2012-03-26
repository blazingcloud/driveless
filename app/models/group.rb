class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  belongs_to :owner, :class_name => "User"
  belongs_to :destination

  validates_presence_of :name, :owner_id, :destination_id
  validates_uniqueness_of :name

  scope :by_name , :order => 'name ASC'

  def self.find_leaderboard(group_ids_sql, user_id, order = :miles)
    order_sql = order.to_sym == :lb_co2 ? 'lb_co2_sum' : 'distance_sum'

    sql = <<-SQL
      SELECT groups.*, COALESCE(distance_sum, 0) AS distance_sum, COALESCE(lb_co2_sum, 0) AS lb_co2_sum FROM groups
      LEFT JOIN (

      SELECT group_id, sum(lb_co2_per_mode_sum) AS lb_co2_sum, sum(distance_per_mode_sum) AS distance_sum FROM (
        SELECT memberships.group_id, trips.mode_id, (modes.lb_co2_per_mile * sum(trips.distance)) AS lb_co2_per_mode_sum, sum(trips.distance) AS distance_per_mode_sum FROM trips
        INNER JOIN memberships ON trips.user_id = memberships.user_id
        INNER JOIN modes ON trips.mode_id = modes.id
        WHERE memberships.group_id IN
        (#{group_ids_sql})
        AND modes.green = ?
        AND trips.made_at >= ?
        GROUP BY memberships.group_id, trips.mode_id, modes.lb_co2_per_mile) AS stats_per_mode
      GROUP BY group_id) AS stats_per_group

      ON stats_per_group.group_id = groups.id
      WHERE groups.id IN
      (#{group_ids_sql})
      ORDER BY #{order_sql} DESC
    SQL

    find_by_sql([sql, user_id, true, Date.new(2012, 4, 22), user_id])
  end

  def stats
    return @stats if @stats

    sql = <<-SQL
      SELECT groups.id, sum(lb_co2_per_mode_sum) AS lb_co2_sum, sum(distance_per_mode_sum) AS distance_sum FROM groups
      INNER JOIN (

        SELECT memberships.group_id, trips.mode_id, (modes.lb_co2_per_mile * sum(trips.distance)) AS lb_co2_per_mode_sum, sum(trips.distance) AS distance_per_mode_sum FROM trips
        INNER JOIN memberships ON trips.user_id = memberships.user_id
        INNER JOIN modes ON trips.mode_id = modes.id
        WHERE memberships.group_id = ?
        AND modes.green = ?
        AND trips.made_at >= ?
        GROUP BY memberships.group_id, trips.mode_id, modes.lb_co2_per_mile) AS stats_per_mode

      ON stats_per_mode.group_id = groups.id
      GROUP BY groups.id
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

  def self.find_leaderboard_owned_by(user, order = :miles)
    group_ids_sql = "SELECT id FROM groups WHERE owner_id = ?"

    find_leaderboard(group_ids_sql, user.id, order)
  end

  def self.find_leaderboard_for_member(user, order = :miles)
    group_ids_sql = "SELECT group_id FROM memberships WHERE user_id = ?"

    find_leaderboard(group_ids_sql, user.id, order)
  end

  def members_leaderboard(order)
    user_ids_sql = "SELECT user_id FROM memberships WHERE group_id = ?"

    User.find_leaderboard(user_ids_sql, id, order)
  end

  def members_leaderboard_by(mode_id)
    user_ids_sql = "SELECT user_id FROM memberships WHERE group_id = ?"

    User.find_leaderboard(user_ids_sql, id, :miles, mode_id)
  end

  def membership_for(user)
    memberships.find_by_user_id(user.id)
  end

  def owned_by?(user)
    owner_id == user.id
  end

  # ==== stats
  def qualified_users
    users.select {|u| u.days_logged >= 5}
  end

  def lbs_co2_saved
    qualified_users.sum { |user| user.lbs_co2_saved }
  end

  def total_miles
    qualified_users.sum {|user| user.trips.qualifying.all.sum {|trip| trip.distance}}
  end

  def category_name
    destination.name
  end

  def num_qualified_users
    qualified_users.size
  end

  def qualified_for_current_challenge?
    qualified_users.size > 2
  end
end
