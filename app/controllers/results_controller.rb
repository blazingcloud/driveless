class ResultsController < ApplicationController
  before_filter :require_admin

  def index
    @categories = [
      {
        :description => "Most Green Miles for All Users by Mode of Transportation",
        :results => Mode.green.map { |mode| result = User.max_miles(mode.name) }
      },

      {
        :description => "Most Green Trips for All Users",
        :results => [User.max_green_trips]
      },

      {
        :description => "Most Green Shopping Trips for All Users",
        :results => [User.max_green_shopping_trips]
      },
    ]

  end
end
