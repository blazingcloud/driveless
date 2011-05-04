class ResultsController < ApplicationController
  before_filter :require_admin

  def index
    @green_mode_results = Mode.green.map do |mode|
      result = User.max_miles(mode.name)
    end
  end
end
