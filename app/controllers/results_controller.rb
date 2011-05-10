class ResultsController < ApplicationController
  before_filter :require_admin

  def index
    @categories = []
    Mode.green.map do |mode| 
      @categories << {
        :description => "Most Green Miles for All Users by #{mode.name}",
        :results => User.max_miles(mode)
      }
    end

    @categories += [
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
