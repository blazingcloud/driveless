class ResultsController < ApplicationController
  before_filter :require_admin
  
  def csv
   filename = "./tmp/driveless-results-#{Time.now.strftime('%YY-%mm-%dd-%H%M')}.csv"
   Result.generate_individuals_csv(filename)
   send_file filename
  end

  def index
    #@categories = []
    #Mode.green.map do |mode| 
      #@categories << {
        #:description => "Most Green Miles for All Users by #{mode.name}",
        #:results => User.max_miles(mode)
      #}
    #end

    #@categories += [
      #{
    #}
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
