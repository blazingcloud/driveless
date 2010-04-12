class User < ActiveRecord::Base
  has_one :baseline
  has_many :trips
  belongs_to :community
  
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
