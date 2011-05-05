class ResultsController < ApplicationController
  before_filter :require_admin

  def index
    @green_mode_results = Mode.green.map do |mode|
      result = User.max_miles(mode.name)
    end
    @most_green_trips_winner = User.max_green_trips
  end
end
