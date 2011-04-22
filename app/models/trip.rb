class Trip < ActiveRecord::Base

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

  scope :current_challenge, where(['made_at >= ?', Date.new(2011, 4, 22)])

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

  private

  def update_green_miles
    user.update_green_miles
  end
  
  def self.graphicable_since(date)
    only_green.made_since(date).summed_by_mode_and_date
  end
end
