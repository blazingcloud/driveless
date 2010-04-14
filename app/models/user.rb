class User < ActiveRecord::Base
  has_one :baseline
  has_many :trips
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  belongs_to :community
  validates_presence_of :email, :username, :password

  attr_protected :admin

  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email]
  end # block optional

  def sum_of_trips
    "%.2f" % self.trips.map(&:distance).sum.to_f
  end

  def percent_of_personal_goal_reached
    "%.2f%" % (self.sum_of_trips.to_f / self.baseline.green_miles.to_f * 100)
  end

  private

  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.username = registration["nickname"] if username.blank?
  end
end
