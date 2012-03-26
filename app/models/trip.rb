class Trip < ActiveRecord::Base

  def self.earth_day
    Date.new(2012, 4, 22)
  end

  def self.current_challenge_period
    earth_day..(earth_day + 13.days)
  end

  # TODO: Remove hack to default scope. This was done for 2012, but it'd be better if we changed
  # the code to use scopes by name instead of using modifying the default scope since this can
  # be confusing.
  # The difference between current_challenge and qualifying is that qualifying
  # has an end date (since we're only counting data logged 4/22 through 5/5 (two
  # weeks). It would be confusing, though if someone entered data for the day
  # after the qualifying period and it just disappeared into the ether, which
  # is the current user experience with entering dates before earth day.
  # See: https://www.pivotaltracker.com/story/show/13309783
  
  scope :qualifying, lambda { where(:made_at => current_challenge_period) }
  scope :current_challenge, where(['made_at >= ?', earth_day])

  def self.find(*args)
    current_challenge.find(*args)
  end

  def self.count(*args)
    current_challenge.count(*args)
  end

  def self.all(*args)
    current_challenge.all(*args)
  end

  def self.first(*args)
    current_challenge.first(*args)
  end
  
  def self.last(*args)
    current_challenge.last(*args)
  end

  belongs_to :user
  belongs_to :destination
  belongs_to :mode
  belongs_to :unit

  attr_accessible :user_id, :destination_id, :mode_id, :unit_id, :distance, :made_at
  validates_presence_of :destination, :mode, :unit, :distance, :made_at
  validates_numericality_of :distance, :greater_than_or_equal_to => 0

  after_save :update_green_miles
  after_destroy :update_green_miles

  scope :not_green, lambda {
    current_challenge.find(:all, :joins => :mode, :conditions => {:"modes.green" => false})
  }

  scope :only_green, lambda {
    current_challenge.find(:all, :joins => :mode, :conditions => {:"modes.green" => true})
  }

  scope :made_since, lambda { |date| {:conditions => ['trips.made_at >= ?', date.to_date]} }

  scope :summed_by_mode_and_date, lambda {
    current_challenge.find(
      :all,
      :select => 'modes.name AS mode_name, trips.made_at, sum(trips.distance) AS distance_sum',
      :joins => :mode,
      :group => 'modes.name, trips.made_at'
    )
  }

  def to_tweet
    "I decided to %s for %0.2f %s on %s and saved %0.2f\lbs of co2 for the @driveless challenge! http://xrl.us/mdlc" % [
      mode.name.downcase,
      distance,
      (distance == 1 ? "mile" : "mile".pluralize()),
      made_at.strftime("%B %d"),
      distance * mode.lb_co2_per_mile
    ]
  end

  def lbs_co2_saved
    distance * mode.lb_co2_per_mile.to_f
  end

  def shopping?
    self.destination.try(:name) == "Errands & Other"
  end

  private

  def update_green_miles
    user.update_green_miles
  end
  
  def self.graphicable_since(date)
    only_green.made_since(date).summed_by_mode_and_date
  end
end
