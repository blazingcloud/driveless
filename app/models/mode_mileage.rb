class ModeMileage < ActiveRecord::Base
  belongs_to :user
  belongs_to :mode
  belongs_to :result
  scope :top_five, lambda { includes(:result).where(["results.qualified = ?", true ]).limit(5).order("mileage desc") }
end
