class User < ActiveRecord::Base
  has_one :baseline
  has_many :trips
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :owned_groups, :class_name => "Group", :foreign_key => :owner_id
  belongs_to :community
  validates_presence_of :email, :username

  before_create :create_baseline

  named_scope :by_green_miles, :order => 'green_miles DESC'

  attr_protected :admin

  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email]
  end # block optional

  def sum_of_trips
    "%.2f" % self.trips.map(&:distance).sum.to_f
  end
  
  def green_miles
    "%.2f" % self.green_trips.map(&:distance).sum.to_f
  end
  
  def green_trips
    self.trips.select{|t| t.mode.green}
  end

  def percent_of_personal_goal_reached
    "%.2f%" % (self.green_miles.to_f / self.baseline.green_miles.to_f * 100)
  end
  
  def lb_co2_saved
    "%.1f" % self.green_trips.map{|t| t.mode.lb_co2_per_mile * t.distance}.sum.to_f
  end

  def regular_memberships
    memberships.except_owned_by(self)
  end

  def create_group(params)
    owned_groups.create(params)
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
