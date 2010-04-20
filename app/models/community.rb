class Community < ActiveRecord::Base
  has_many :users
  validates_presence_of :name, :state, :country

  before_destroy :ensure_there_are_no_members

  # Is there any 'rubiest' way to do this?
  named_scope :by_green_miles,
    :select => ['communities.id, communities.name, communities.state, communities.country, 
      communities.description, SUM(users.green_miles) as green_miles, SUM(users.green_miles)*modes.lb_co2_per_mile'],
    :joins => [:users => {:trips => :mode}],
    :group => ['users.community_id, trips.user_id, communities.id, communities.name, communities.state, communities.country, communities.description']

  def lb_co2_saved
     self.users.map{|u| u.lb_co2_saved.to_f}.sum
  end

  private

  def ensure_there_are_no_members
    raise "This community can't be deleted as there are #{users.count} users in it" if users.any?
  end
end
