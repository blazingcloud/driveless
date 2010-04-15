class Trip < ActiveRecord::Base
  belongs_to :user
  belongs_to :destination
  belongs_to :mode
  belongs_to :unit
  attr_accessible :user_id, :destination_id, :mode_id, :unit_id, :distance, :made_at

  after_save :update_green_miles
  after_destroy :update_green_miles

  named_scope :only_green, :joins => :mode, :conditions => {:"modes.green" => true}

  private

  def update_green_miles
    user.update_green_miles
  end
end
